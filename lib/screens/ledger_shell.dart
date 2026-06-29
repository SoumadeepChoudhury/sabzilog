import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/models/advance_transaction.dart';
import 'package:logger/supabase/SupabaseImageService.dart';
import 'package:logger/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../models/user_role.dart';
import '../models/veg_entry.dart';
import '../sheets/add_advance_sheet.dart';
import '../sheets/capture_sheet.dart';
import '../sheets/settle_balance_sheet.dart';
import 'activity_page.dart';
import 'balance_page.dart';
import 'home_page.dart';
import 'maid_home_page.dart';
import 'settings_page.dart';

class LedgerShell extends StatefulWidget {
  const LedgerShell({required this.role, required this.onLogout, super.key});

  final UserRole role;
  final VoidCallback onLogout;

  @override
  State<LedgerShell> createState() => _LedgerShellState();
}

class _LedgerShellState extends State<LedgerShell> {
  int _selectedIndex = 0;
  double _advanceBalance = 0;
  bool isLoading = false;
  double spentToday = 0;
  double lastAdvance = 0;
  final List<VegEntry> _entries = [];

  List<AdvanceTransaction> rawTransactions = [];

  Future<List<Map<String, dynamic>>> getAllLogs() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('logs')
          .get();

      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      print('Error fetching logs: $e');
      return [];
    }
  }

  void setInitialLogs() async {
    setState(() => isLoading = true);

    final logs = await getAllLogs();
    _entries.clear();

    List<VegEntry> _tempEntries = [];
    double _spentToday = 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final log in logs) {
      _tempEntries.add(
        VegEntry(
          id: log['id'],
          amount: log['price'] ?? 0,
          time: (log['created_at'] as Timestamp?)?.toDate().toString() ?? '',
          weight: log['weight'] ?? '0',
          status: LogStatus.values.firstWhere(
            (e) => e.toString() == log['status'],
            orElse: () => LogStatus.pending,
          ),
          photoUrl: log['photo_url'],
          photoTone: const [Color(0xFF6BAF62), Color(0xFFE35D42)],
        ),
      );
      final DateTime createdAt = (log['created_at'] as Timestamp).toDate();
      final transactionDate = DateTime(
        createdAt.year,
        createdAt.month,
        createdAt.day,
      );

      if (transactionDate.isAtSameMomentAs(today))
        _spentToday += log['price'] as int;
    }
    setState(() {
      isLoading = false;
      _entries.addAll(_tempEntries);
      spentToday = _spentToday;
    });
  }

  void getBalance() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('balance')
        .doc('data')
        .get();
    if (snapshot.exists) {
      double price = 0;

      try {
        final transactions = snapshot.get('transaction');
        // getting the transaction history
        rawTransactions = transactions.map<AdvanceTransaction>((item) {
          final key = item.keys.first;
          final value = item.values.first;

          return AdvanceTransaction(date: DateTime.parse(key), amount: value);
        }).toList();

        rawTransactions.sort((a, b) => b.date.compareTo(a.date));

        if (transactions.isNotEmpty) {
          final Map<String, dynamic> lastTransaction =
              transactions.last as Map<String, dynamic>;
          final values = lastTransaction.values.toList();

          if (values.isNotEmpty) {
            price = values.first as double;
          }
        }
      } catch (e) {
        debugPrint("Error: $e");
        rawTransactions = [];
      }
      setState(() {
        _advanceBalance = snapshot.get('balance');
        lastAdvance = price;
      });
    }
  }

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        checkUpdate(context);
      } catch (e) {
        print("Error while checking update...");
      }
    });
    super.initState();
    // Load initial data
    setInitialLogs();
    getBalance();
  }

  int get _pendingCount =>
      _entries.where((entry) => entry.status == LogStatus.pending).length;

  @override
  Widget build(BuildContext context) {
    final isOwner = widget.role == UserRole.owner;
    final pages = isOwner ? _ownerPages() : _maidPages();
    final destinations = isOwner ? _ownerDestinations : _maidDestinations;

    return Scaffold(
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: destinations,
      ),
      floatingActionButton: isOwner
          ? null
          : FloatingActionButton.extended(
              onPressed: _openCaptureSheet,
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('New log'),
            ),
    );
  }

  List<Widget> _ownerPages() {
    return [
      HomePage(
        balance: _advanceBalance,
        spentToday: spentToday,
        pendingCount: _pendingCount,
        entries: _entries,
        onAddAdvance: _openAdvanceSheet,
        onSettle: _openSettleSheet,
        isLoading: isLoading,
        setInitialLogs: () {
          setInitialLogs();
          getBalance();
        },
        onViewAllLogs: () => setState(() {
          _selectedIndex = 1;
        }),
        role: widget.role,
      ),
      ActivityPage(
        entries: _entries,
        isLoading: isLoading,
        setInitialLogs: () {
          setInitialLogs();
          getBalance();
        },
        role: widget.role,
      ),
      BalancePage(
        balance: _advanceBalance,
        spentToday: spentToday,
        lastAdvance: lastAdvance,
        entries: _entries,
        onAddAdvance: _openAdvanceSheet,
        onSettle: _openSettleSheet,
        rawTransactions: rawTransactions,
        setInitialLogs: () {
          setInitialLogs();
          getBalance();
        },
      ),
      SettingsPage(onLogout: widget.onLogout),
    ];
  }

  List<Widget> _maidPages() {
    return [
      MaidHomePage(
        balance: _advanceBalance,
        spentToday: spentToday,
        entries: _entries,
        onCapture: _openCaptureSheet,
        isLoading: isLoading,
        setInitialLogs: () {
          setInitialLogs();
          getBalance();
        },
        onViewAllLogs: () => {
          setState(() {
            _selectedIndex = 1;
          }),
        },
      ),
      ActivityPage(
        entries: _entries,
        isLoading: isLoading,
        setInitialLogs: () {
          setInitialLogs();
          getBalance();
        },
        role: widget.role,
      ),
      SettingsPage(onLogout: widget.onLogout),
    ];
  }

  static const _ownerDestinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: 'Logs',
    ),
    NavigationDestination(
      icon: Icon(Icons.account_balance_wallet_outlined),
      selectedIcon: Icon(Icons.account_balance_wallet),
      label: 'Balance',
    ),
    NavigationDestination(
      icon: Icon(Icons.tune_outlined),
      selectedIcon: Icon(Icons.tune),
      label: 'Setup',
    ),
  ];

  static const _maidDestinations = [
    NavigationDestination(
      icon: Icon(Icons.add_a_photo_outlined),
      selectedIcon: Icon(Icons.add_a_photo),
      label: 'Submit',
    ),
    NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: 'My logs',
    ),
    NavigationDestination(
      icon: Icon(Icons.tune_outlined),
      selectedIcon: Icon(Icons.tune),
      label: 'Setup',
    ),
  ];

  void _openCaptureSheet() async {
    final picker = ImagePicker();

    Future<File?> pickImage() async {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    }

    // try {
    //   await pickImage();
    // } catch (e) {
    //   // Handle any errors that occur during image picking
    //   debugPrint('Error picking image: $e');
    // }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final id = Uuid().v4();
        return CaptureSheet(
          pickImage: pickImage,
          onSave: (amount, weight, photo) async {
            setState(() {
              _advanceBalance -= amount;
              spentToday += amount;

              _entries.insert(
                0,
                VegEntry(
                  id: id,
                  amount: amount,
                  weight: weight,
                  time: DateTime.now().toString(),
                  status: LogStatus.pending,
                  photoUrl: photo.path,
                  photoTone: const [Color(0xFF6BAF62), Color(0xFFE35D42)],
                ),
              );
            });
            try {
              final supabaseImageService = SupabaseImageService();

              final photoUrl = await supabaseImageService.pickCompressAndUpload(
                photo,
              );

              if (photoUrl == null) {
                debugPrint('Upload failed');
                return;
              }

              debugPrint('Image uploaded to: $photoUrl');

              await FirebaseFirestore.instance.collection('logs').doc(id).set({
                'photo_url': photoUrl,
                'price': amount,
                'weight': weight,
                'created_at': DateTime.now(),
                'status': LogStatus.pending.toString(),
              });

              await FirebaseFirestore.instance
                  .collection('balance')
                  .doc('data')
                  .update({'balance': FieldValue.increment(-amount)});

              debugPrint('Saved successfully');
            } catch (e) {
              debugPrint('Error: $e');
            }
          },
        );
      },
    );
  }

  void _openAdvanceSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return AddAdvanceSheet(
          onAdd: (amount) async {
            await FirebaseFirestore.instance
                .collection('balance')
                .doc('data')
                .update({
                  'balance': FieldValue.increment(amount),
                  'transaction': FieldValue.arrayUnion([
                    {'${DateTime.now()}': amount},
                  ]),
                });
            setState(() {
              _advanceBalance += amount;
              lastAdvance = amount;
            });
          },
        );
      },
    );
  }

  void _openSettleSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SettleBalanceSheet(
          currentBalance: _advanceBalance,
          onSettle: (amount) async {
            setState(() {
              _advanceBalance += amount;
              lastAdvance = _advanceBalance;
            });
            Map<String, dynamic> tempMap;
            if (lastAdvance > 0) {
              tempMap = {
                'balance': FieldValue.increment(amount),
                'transaction': FieldValue.arrayUnion([
                  {'${DateTime.now()}': lastAdvance},
                ]),
              };
            } else {
              tempMap = {'balance': FieldValue.increment(amount)};
            }
            await FirebaseFirestore.instance
                .collection('balance')
                .doc('data')
                .update(tempMap);
          },
        );
      },
    );
  }
}
