import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/models/advance_transaction.dart';
import 'package:logger/screens/advance_history_page.dart';

import '../models/veg_entry.dart';
import '../widgets/app_widgets.dart';

class BalancePage extends StatelessWidget {
  const BalancePage({
    required this.balance,
    required this.spentToday,
    required this.entries,
    required this.onAddAdvance,
    required this.onSettle,
    required this.lastAdvance,
    required this.rawTransactions,
    super.key,
  });

  final int balance;
  final int spentToday;
  final int lastAdvance;
  final List<VegEntry> entries;
  final VoidCallback onAddAdvance;
  final VoidCallback onSettle;
  final List<AdvanceTransaction> rawTransactions;

  @override
  Widget build(BuildContext context) {
    final totalSpent = entries.fold<int>(
      0,
      (total, entry) => total + entry.amount,
    );

    return ListView(
      key: const ValueKey('balance_page_scroll'),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      children: [
        Text('Balance book', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 14),
        BalanceHero(
          balance: balance,
          spentToday: spentToday,
          pendingCount: entries
              .where((e) => e.status == LogStatus.pending)
              .length,
          onAddAdvance: onAddAdvance,
          onSettle: onSettle,
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: MediaQuery.sizeOf(context).width > 540 ? 3 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.55,
          children: [
            SummaryCard(
              icon: Icons.payments_outlined,
              label: 'Total spent',
              value: 'Rs $totalSpent',
            ),
            SummaryCard(
              icon: Icons.history_outlined,
              label: 'Last advance',
              value: 'Rs $lastAdvance',
            ),
            SummaryCard(
              icon: Icons.receipt_long_outlined,
              label: 'Total logs',
              value: '${entries.length}',
            ),
            const SummaryCard(
              icon: Icons.check_circle_outline,
              label: 'Settlement',
              value: 'Tonight',
            ),
          ],
        ),
        const SizedBox(height: 18),
        MonthlyReportCard(balance: balance, entries: entries),
        const SizedBox(height: 18),

        SectionHeader(
          title: 'Advance History',
          actionLabel: rawTransactions.length > 3 ? 'View all' : null,
          onAction: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    AdvanceHistoryPage(transactions: rawTransactions),
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        ...rawTransactions
            .take(5)
            .map(
              (tx) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.payments_outlined),
                  ),
                  title: Text('₹${tx.amount}'),
                  subtitle: Text(
                    DateFormat('dd MMM yyyy • hh:mm a').format(tx.date),
                  ),
                ),
              ),
            ),
        const SizedBox(height: 18),
        SectionHeader(
          title: 'Owner actions',
          actionLabel: 'Export',
          onAction: () {},
        ),
        const SizedBox(height: 8),
        ActionRow(
          icon: Icons.payments_outlined,
          title: balance < 0 ? 'Clear amount due' : 'Add future advance',
          subtitle: balance < 0
              ? 'Owner owes Rs ${balance.abs()}. Pay exact due or include extra advance.'
              : 'Record more money given for future purchases.',
          buttonLabel: 'Settle',
          onTap: onSettle,
        ),
        ActionRow(
          icon: Icons.verified_user_outlined,
          title: 'Approve pending logs',
          subtitle: 'Mark today as checked after matching photos.',
          buttonLabel: 'Approve',
          onTap: () {},
        ),
        ActionRow(
          icon: Icons.picture_as_pdf_outlined,
          title: 'Monthly statement',
          subtitle: 'Keep a shareable record for both sides.',
          buttonLabel: 'Make',
          onTap: () {},
        ),
      ],
    );
  }
}
