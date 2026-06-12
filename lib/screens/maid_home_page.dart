import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/utils/utils.dart';

import '../models/veg_entry.dart';
import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class MaidHomePage extends StatelessWidget {
  const MaidHomePage({
    required this.balance,
    required this.spentToday,
    required this.entries,
    required this.onCapture,
    required this.setInitialLogs,
    required this.onViewAllLogs,
    this.isLoading = false,
    super.key,
  });

  final int balance;
  final int spentToday;
  final List<VegEntry> entries;
  final VoidCallback onCapture;
  final bool isLoading;

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
          const HeaderBar(subtitle: 'My purchase logs and balance'),
          const SizedBox(height: 18),
          _MaidHero(
            balance: balance,
            spentToday: spentToday,
            spentThisMonth: entries.fold(0, (sum, entry) => sum + entry.amount),
            onCapture: onCapture,
          ),
          const SizedBox(height: 22),
          SectionHeader(
            title: 'Recent Logs',
            actionLabel: entries.isEmpty ? null : 'View all',
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
              ...entries.take(5).map((entry) => _LogTile(entry: entry)),
            ],
          ],
          const SizedBox(height: 22),
          // const SmartReminders(),
        ],
      ),
    );
  }
}

class _MaidHero extends StatelessWidget {
  const _MaidHero({
    required this.balance,
    required this.spentToday,
    required this.spentThisMonth,
    required this.onCapture,
  });

  final int balance;
  final int spentToday;
  final int spentThisMonth;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    final headline = 'Your Balance';
    final amountText = '₹$balance';
    final helperText =
        'Keep track of your daily vegetable purchases and advances.';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headline,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: .72),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amountText,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontSize: 38,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            helperText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: .68),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: MetricPill(
                  icon: Icons.today_outlined,
                  label: 'Spent today',
                  value: '₹$spentToday',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricPill(
                  icon: Icons.history_outlined,
                  label: 'Spent This Month',
                  value: '₹$spentThisMonth',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onCapture,
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Capture New Log'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.entry});

  final VegEntry entry;

  @override
  Widget build(BuildContext context) {
    final style = statusStyle(entry.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: .05)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: entry.photoUrl == null
                ? null
                : () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder: (_) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(12),
                        child: Stack(
                          children: [
                            InteractiveViewer(
                              minScale: 0.5,
                              maxScale: 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  entry.photoUrl!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: LinearGradient(colors: entry.photoTone),
              ),
              child: entry.photoUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: entry.photoUrl!.startsWith('http')
                          ? Image.network(entry.photoUrl!, fit: BoxFit.cover)
                          : Image.file(
                              File(entry.photoUrl!),
                              fit: BoxFit.cover,
                            ),
                    )
                  : const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.black26,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹ ${entry.amount.toString()}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      entry.weight.toString(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
                Text(
                  formatLogTime(entry.time),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: style.color.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(style.icon, size: 12, color: style.color),
                const SizedBox(width: 4),
                Text(
                  style.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: style.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
