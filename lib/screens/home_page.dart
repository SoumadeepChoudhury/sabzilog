import 'package:flutter/material.dart';
import 'package:logger/models/user_role.dart';

import '../models/veg_entry.dart';
import '../widgets/app_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.balance,
    required this.spentToday,
    required this.pendingCount,
    required this.entries,
    required this.onAddAdvance,
    required this.onSettle,
    required this.isLoading,
    required this.setInitialLogs,
    required this.onViewAllLogs,
    required this.role,
    super.key,
  });

  final double balance;
  final double spentToday;
  final int pendingCount;
  final bool isLoading;
  final List<VegEntry> entries;
  final VoidCallback onAddAdvance;
  final VoidCallback onSettle;
  final UserRole role;
  final void Function() setInitialLogs;
  final void Function() onViewAllLogs;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setInitialLogs();
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
        children: [
          const HeaderBar(),
          const SizedBox(height: 18),
          BalanceHero(
            balance: balance,
            spentToday: spentToday,
            pendingCount: pendingCount,
            onAddAdvance: onAddAdvance,
            onSettle: onSettle,
          ),
          const SizedBox(height: 16),
          OwnerReviewCard(pendingCount: pendingCount, onSettle: onSettle),
          const SizedBox(height: 22),
          SectionHeader(
            title: 'Today',
            actionLabel: 'Review all',
            onAction: onViewAllLogs,
          ),
          if (isLoading) ...[
            Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            ),
          ] else ...[
            if (entries.isEmpty) ...[
              const SizedBox(height: 40),
              const Center(child: EmptyState3D()),
              const SizedBox(height: 40),
            ] else ...[
              const SizedBox(height: 10),
              ...entries.take(3).map((e) => EntryTile(e, role)),
            ],
          ],
          const SizedBox(height: 22),
          const SmartReminders(),
        ],
      ),
    );
  }
}
