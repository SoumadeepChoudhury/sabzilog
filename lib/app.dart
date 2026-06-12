import 'package:flutter/material.dart';
import 'package:logger/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/firebase.dart';
import 'models/user_role.dart';
import 'screens/auth_page.dart';
import 'screens/ledger_shell.dart';
import 'theme/app_theme.dart';

class VegLogApp extends StatefulWidget {
  const VegLogApp({super.key});

  @override
  State<VegLogApp> createState() => _VegLogAppState();
}

class _VegLogAppState extends State<VegLogApp> {
  UserRole? _signedInRole;
  bool _initializing = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    final user = _authService.currentUser;
    if (user != null) {
      // User is signed into Firebase, now we need to remember their role
      final prefs = await SharedPreferences.getInstance();
      final roleString = prefs.getString('user_role');

      // if (roleString == 'owner') {
      //   setState(() => _signedInRole = UserRole.owner);
      // } else if (roleString == 'maid') {
      //   setState(() => _signedInRole = UserRole.maid);
      // } else {
      //   // Signed in but no role saved, send back to AuthPage to pick a role
      //   setState(() => _signedInRole = null);
      // }
      UserRole? role;
      if (roleString == 'owner') {
        role = UserRole.owner;
      } else if (roleString == 'maid') {
        role = UserRole.maid;
      }

      // 2. CRITICAL STEP: Update the Global Provider!
      // This tells the Profile page and other screens that the user is here.
      if (role != null) {
        Provider.of<AuthProvider>(context, listen: false).setUser(user, role);
      }

      if (role != null) {
        setState(() => _signedInRole = role);
      } else {
        setState(() => _signedInRole = null);
      }
    } else {
      setState(() => _signedInRole = null);
    }
    setState(() => _initializing = false);
  }

  Future<void> _handleContinue(UserRole role) async {
    // Save the role locally so we remember it next time
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role.name);

    setState(() => _signedInRole = role);
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sabzi Log',
      theme: AppTheme.light,
      home: _signedInRole == null
          ? AuthPage(
              onContinue: (role) {
                _handleContinue(role);
              },
            )
          : LedgerShell(
              role: _signedInRole!,
              onLogout: () async {
                // Clear role and sign out
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('user_role');
                await _authService.signOut();
                setState(() => _signedInRole = null);
              },
            ),
    );
  }
}
