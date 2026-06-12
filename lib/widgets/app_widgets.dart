import 'dart:io';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/models/user_role.dart';
import 'package:logger/utils/utils.dart';
import 'package:lottie/lottie.dart';

import '../models/veg_entry.dart';
import '../theme/app_theme.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    this.subtitle = 'Maid expense proof and balance',
    super.key,
  });

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFE9F1E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.local_florist, color: AppTheme.seed),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sabzi Log', style: Theme.of(context).textTheme.titleLarge),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: .58),
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: () {},
          tooltip: 'Notifications',
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }
}

class BalanceHero extends StatelessWidget {
  const BalanceHero({
    required this.balance,
    required this.spentToday,
    required this.pendingCount,
    required this.onAddAdvance,
    required this.onSettle,
    super.key,
  });

  final int balance;
  final int spentToday;
  final int pendingCount;
  final VoidCallback onAddAdvance;
  final VoidCallback onSettle;

  @override
  Widget build(BuildContext context) {
    final ownerOwes = balance < 0;
    final lowBalance = balance >= 0 && balance < 50;
    final headline = ownerOwes ? 'Owner owes maid' : 'Advance balance';
    final amountText = ownerOwes ? 'Rs ${balance.abs()}' : 'Rs $balance';
    final helperText = ownerOwes
        ? 'Clear due or include extra future advance.'
        : balance == 0
        ? 'Everything is settled. Add future advance when needed.'
        : 'Maid still has this amount for future purchases.';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.ink,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  headline,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: .72),
                  ),
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: ownerOwes ? onSettle : onAddAdvance,
                icon: Icon(ownerOwes ? Icons.payments_outlined : Icons.add),
                label: Text(ownerOwes ? 'Settle due' : 'Add advance'),
              ),
            ],
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
                  icon: Icons.shopping_basket_outlined,
                  label: 'Today spent',
                  value: 'Rs $spentToday',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricPill(
                  icon: Icons.hourglass_bottom_outlined,
                  label: 'Pending',
                  value: '$pendingCount logs',
                ),
              ),
            ],
          ),
          if (ownerOwes) ...[
            const SizedBox(height: 12),
            const AlertStrip(
              icon: Icons.payments_outlined,
              text:
                  'Expenses crossed the advance. Owner needs to settle this due.',
            ),
          ] else if (lowBalance) ...[
            const SizedBox(height: 12),
            const AlertStrip(
              icon: Icons.error_outline,
              text: 'Balance is getting low. Add advance soon.',
            ),
          ],
        ],
      ),
    );
  }
}

class MetricPill extends StatelessWidget {
  const MetricPill({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: .62),
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuickCaptureCard extends StatelessWidget {
  const QuickCaptureCard({required this.onCapture, super.key});

  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE2C2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.camera_alt, color: Color(0xFF974D21)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fast maid entry',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Capture photo, enter price, save. Details can be reviewed later.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black.withValues(alpha: .58),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            onPressed: onCapture,
            tooltip: 'Capture expense',
            icon: const Icon(Icons.add_a_photo_outlined),
          ),
        ],
      ),
    );
  }
}

class OwnerReviewCard extends StatelessWidget {
  const OwnerReviewCard({
    required this.pendingCount,
    required this.onSettle,
    super.key,
  });

  final int pendingCount;
  final VoidCallback onSettle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F1E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: AppTheme.seed,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Owner review',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '$pendingCount pending logs need checking before final settlement.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black.withValues(alpha: .58),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            onPressed: onSettle,
            tooltip: 'Settle balance',
            icon: const Icon(Icons.fact_check_outlined),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class EntryTile extends StatefulWidget {
  const EntryTile(this.entry, this.role, {super.key});

  final VegEntry entry;
  final UserRole? role;

  @override
  State<EntryTile> createState() => _EntryTileState();
}

class _EntryTileState extends State<EntryTile> {
  @override
  Widget build(BuildContext context) {
    final currentStatus = statusStyle(widget.entry.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: .06)),
      ),
      child: Row(
        children: [
          PhotoThumb(
            colors: widget.entry.photoTone,
            photoUrl: widget.entry.photoUrl,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Rs ${widget.entry.amount}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SmallLabel(
                      icon: Icons.monitor_weight_outlined,
                      label:
                          '${widget.entry.weight}                                            ',
                    ),
                    SmallLabel(
                      icon: Icons.schedule,
                      label: formatLogTime(widget.entry.time),
                    ),
                    StatusChip(
                      style: currentStatus,
                      role: widget.role, // Pass the role from your Provider
                      onStatusChanged: (newStatus) async {
                        setState(() {
                          widget.entry.status = newStatus;
                        });
                        await FirebaseFirestore.instance
                            .collection('logs')
                            .doc(widget.entry.id)
                            .update({'status': newStatus.toString()});
                      },
                    ),
                  ],
                ),
                if (widget.entry.note != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    widget.entry.note!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: currentStatus.color),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoThumb extends StatelessWidget {
  const PhotoThumb({required this.colors, this.photoUrl, super.key});

  final List<Color> colors;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: photoUrl == null
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
                          child: Image.network(photoUrl!, fit: BoxFit.contain),
                        ),
                      ),

                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(colors: colors),
        ),
        child: photoUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: photoUrl!.startsWith('http')
                    ? Image.network(photoUrl!, fit: BoxFit.cover)
                    : Image.file(File(photoUrl!), fit: BoxFit.cover),
              )
            : const Icon(
                Icons.image_not_supported_outlined,
                color: Colors.black26,
              ),
      ),
    );
  }
}

class SmallLabel extends StatelessWidget {
  const SmallLabel({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.black.withValues(alpha: .48)),
        const SizedBox(width: 3),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.black.withValues(alpha: .58),
          ),
        ),
      ],
    );
  }
}

// class StatusChip extends StatelessWidget {
//   const StatusChip({required this.style, super.key});

//   final StatusStyle style;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: style.color.withValues(alpha: .1),
//         borderRadius: BorderRadius.circular(99),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(style.icon, size: 13, color: style.color),
//           const SizedBox(width: 4),
//           Text(
//             style.label,
//             style: Theme.of(context).textTheme.labelSmall?.copyWith(
//               color: style.color,
//               fontWeight: FontWeight.w800,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.style,
    this.role,
    this.onStatusChanged,
    super.key,
  });

  final StatusStyle style;
  final UserRole? role; // To know if current user is Owner
  final Function(LogStatus newStatus)?
  onStatusChanged; // Callback to update status

  @override
  Widget build(BuildContext context) {
    // Define the visual part of the chip to avoid duplication
    Widget chipContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 13, color: style.color),
          const SizedBox(width: 4),
          Text(
            style.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: style.color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    // If the user is NOT an owner, just show the static chip
    if (role != UserRole.owner) {
      return chipContent;
    }

    PopupMenuItem<LogStatus> buildStatusMenuItem(
      BuildContext context,
      LogStatus status,
    ) {
      final s = statusStyle(status);

      return PopupMenuItem<LogStatus>(
        value: status,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: s.color.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: Icon(s.icon, size: 16, color: s.color),
            ),
            const SizedBox(width: 10),
            Text(
              s.label,
              style: TextStyle(color: s.color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    // If the user IS an owner, wrap the chip in a PopupMenuButton
    return PopupMenuButton<LogStatus>(
      padding: EdgeInsets.zero,
      offset: const Offset(0, 30), // Positions the menu below the chip
      onSelected: (LogStatus status) {
        if (onStatusChanged != null) {
          onStatusChanged!(status);
        }
      },
      itemBuilder: (context) => [
        buildStatusMenuItem(context, LogStatus.pending),
        buildStatusMenuItem(context, LogStatus.accepted),
        buildStatusMenuItem(context, LogStatus.question),
      ],
      child: chipContent, // The chip acts as the button
    );
  }
}

class AlertStrip extends StatelessWidget {
  const AlertStrip({required this.icon, required this.text, super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8A5B00), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF5E3E00),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmartReminders extends StatelessWidget {
  const SmartReminders({super.key});

  @override
  Widget build(BuildContext context) {
    final reminders = [
      (
        'Voice note fallback',
        Icons.mic_none,
        'For days when typing names is hard.',
      ),
      (
        'Daily close',
        Icons.fact_check_outlined,
        'Owner can approve pending logs at night.',
      ),
      (
        'Low balance alert',
        Icons.savings_outlined,
        'Warn before the maid runs out of advance.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Useful safeguards',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        ...reminders.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4EA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(item.$2, color: AppTheme.seed),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$1,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        item.$3,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black.withValues(alpha: .56),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FilterPill extends StatelessWidget {
  const FilterPill({
    required this.label,
    required this.onSelected,
    this.selected = false,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}

class EmptyLogState extends StatelessWidget {
  const EmptyLogState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: .06)),
      ),
      child: Column(
        children: [
          const Icon(Icons.filter_alt_off_outlined, color: AppTheme.seed),
          const SizedBox(height: 8),
          Text(
            'No logs match this filter',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Try another status to continue reviewing.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black.withValues(alpha: .56),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppTheme.seed),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black.withValues(alpha: .55),
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MonthlyReportCard extends StatelessWidget {
  const MonthlyReportCard({
    required this.balance,
    required this.entries,
    super.key,
  });

  final int balance;
  final List<VegEntry> entries;

  @override
  Widget build(BuildContext context) {
    final totalSpent = entries.fold<int>(
      0,
      (total, entry) => total + entry.amount,
    );
    // final categoryTotals = <String, int>{};
    // for (final entry in entries) {
    //   categoryTotals.update(
    //     entry.category ?? 'Uncategorized',
    //     (value) => value + entry.amount,
    //     ifAbsent: () => entry.amount,
    //   );
    // }
    // final sortedCategories = categoryTotals.entries.toList()
    //   ..sort((a, b) => b.value.compareTo(a.value));
    final totalGiven = totalSpent + balance;
    final ownerOwes = balance < 0;
    final balanceLabel = ownerOwes ? 'Owner owes' : 'Advance left';
    final balanceIcon = ownerOwes
        ? Icons.payments_outlined
        : Icons.account_balance_wallet_outlined;
    final balanceColor = ownerOwes ? const Color(0xFFB23A2F) : AppTheme.seed;
    final chartTotal = math.max(totalGiven, totalSpent);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: .06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F1E8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bar_chart, color: AppTheme.seed),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly report',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Money flow for May',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black.withValues(alpha: .56),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _MoneyFlowChart(
            totalGiven: totalGiven,
            totalSpent: totalSpent,
            balance: balance,
            chartTotal: chartTotal,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ownerOwes
                  ? const Color(0xFFFFF4D6)
                  : const Color(0xFFEFF4EA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(balanceIcon, color: balanceColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        balanceLabel,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      'Rs ${balance.abs()}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: balanceColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  ownerOwes
                      ? 'Spending crossed the money given. Owner needs to pay this amount.'
                      : 'This amount is still available with the maid for future purchases.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black.withValues(alpha: .62),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MoneyFlowTile(
                  icon: Icons.add_card_outlined,
                  label: 'Given by owner',
                  value: 'Rs $totalGiven',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MoneyFlowTile(
                  icon: Icons.shopping_basket_outlined,
                  label: 'Spent by maid',
                  value: 'Rs $totalSpent',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Text(
          //         'Category split',
          //         style: Theme.of(context).textTheme.titleSmall,
          //       ),
          //     ),
          //     Text(
          //       '${entries.length} logs',
          //       style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //         color: Colors.black.withValues(alpha: .56),
          //         fontWeight: FontWeight.w700,
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 8),
          // if (sortedCategories.isEmpty)
          //   Text(
          //     'No expenses logged yet.',
          //     style: Theme.of(context).textTheme.bodySmall,
          //   )
          // else
          //   Wrap(
          //     spacing: 8,
          //     runSpacing: 8,
          //     children: sortedCategories
          //         .take(3)
          //         .map(
          //           (category) => _CategorySpendTile(
          //             label: category.key,
          //             amount: category.value,
          //             percent: totalSpent == 0
          //                 ? 0
          //                 : ((category.value / totalSpent) * 100).round(),
          //           ),
          //         )
          //         .toList(),
          //   ),
        ],
      ),
    );
  }
}

class _MoneyFlowChart extends StatelessWidget {
  const _MoneyFlowChart({
    required this.totalGiven,
    required this.totalSpent,
    required this.balance,
    required this.chartTotal,
  });

  final int totalGiven;
  final int totalSpent;
  final int balance;
  final int chartTotal;

  @override
  Widget build(BuildContext context) {
    final ownerOwes = balance < 0;
    final headline = ownerOwes ? 'Owed' : 'Left';
    final accent = ownerOwes ? const Color(0xFFB23A2F) : AppTheme.seed;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 132,
            height: 132,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size.square(132),
                  painter: _MoneyFlowDonutPainter(
                    given: totalGiven,
                    spent: totalSpent,
                    chartTotal: chartTotal,
                    accent: accent,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      headline,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.black.withValues(alpha: .52),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Rs ${balance.abs()}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: accent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash flow',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                _ChartLegendDot(
                  color: AppTheme.seed,
                  label: 'Given',
                  value: 'Rs $totalGiven',
                ),
                const SizedBox(height: 8),
                _ChartLegendDot(
                  color: const Color(0xFF2E7D9A),
                  label: 'Spent',
                  value: 'Rs $totalSpent',
                ),
                const SizedBox(height: 8),
                _ChartLegendDot(
                  color: accent,
                  label: ownerOwes ? 'Due' : 'Available',
                  value: 'Rs ${balance.abs()}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoneyFlowDonutPainter extends CustomPainter {
  const _MoneyFlowDonutPainter({
    required this.given,
    required this.spent,
    required this.chartTotal,
    required this.accent,
  });

  final int given;
  final int spent;
  final int chartTotal;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Offset.zero & size;
    final strokeWidth = size.width * .13;
    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFE4ECE4);
    final givenPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppTheme.seed;
    final spentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * .62
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF2E7D9A);
    final accentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = accent;

    canvas.drawCircle(center, (size.width - strokeWidth) / 2, basePaint);

    final start = -math.pi / 2;
    final safeTotal = chartTotal <= 0 ? 1 : chartTotal;
    final givenSweep = (given / safeTotal).clamp(0.0, 1.0) * math.pi * 2;
    final spentSweep = (spent / safeTotal).clamp(0.0, 1.0) * math.pi * 2;

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      start,
      givenSweep,
      false,
      givenPaint,
    );
    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      start,
      spentSweep,
      false,
      spentPaint,
    );

    if (spent > given) {
      final owedSweep =
          ((spent - given) / safeTotal).clamp(0.0, 1.0) * math.pi * 2;
      canvas.drawArc(
        rect.deflate(strokeWidth / 2),
        start + givenSweep,
        owedSweep,
        false,
        accentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MoneyFlowDonutPainter oldDelegate) {
    return oldDelegate.given != given ||
        oldDelegate.spent != spent ||
        oldDelegate.chartTotal != chartTotal ||
        oldDelegate.accent != accent;
  }
}

class _ChartLegendDot extends StatelessWidget {
  const _ChartLegendDot({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black.withValues(alpha: .58),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _MoneyFlowTile extends StatelessWidget {
  const _MoneyFlowTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.seed),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.black.withValues(alpha: .55),
            ),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

// class _CategorySpendTile extends StatelessWidget {
//   const _CategorySpendTile({
//     required this.label,
//     required this.amount,
//     required this.percent,
//   });

//   final String label;
//   final int amount;
//   final int percent;

//   @override
//   Widget build(BuildContext context) {
//     final activeBars = (percent / 20).ceil().clamp(1, 5);

//     return Container(
//       width: 142,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8F6F0),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.black.withValues(alpha: .04)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: Theme.of(
//               context,
//             ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w800),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Expanded(
//                 child: Text(
//                   'Rs $amount',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//               ),
//               Text(
//                 '$percent%',
//                 style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                   color: AppTheme.seed,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: List.generate(
//               5,
//               (index) => Expanded(
//                 child: Container(
//                   height: 16 + (index.isEven ? 8 : 0),
//                   margin: EdgeInsets.only(right: index == 4 ? 0 : 4),
//                   decoration: BoxDecoration(
//                     color: index < activeBars
//                         ? AppTheme.seed
//                         : const Color(0xFFE1EAE1),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class EmptyState3D extends StatelessWidget {
  const EmptyState3D({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 250,
            height: 150,
            child: Lottie.asset(
              'assets/lottie/empty.json',
              repeat: true,
              animate: true,
            ),
          ),

          const SizedBox(height: 16),

          Text('No logs yet!', style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: 6),

          Text(
            'Your laundry of vegetables will appear here.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class ActionRow extends StatelessWidget {
  const ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.seed),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black.withValues(alpha: .56),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: onTap, child: Text(buttonLabel)),
        ],
      ),
    );
  }
}

class PersonCard extends StatelessWidget {
  const PersonCard({
    required this.name,
    required this.role,
    required this.phone,
    required this.icon,
    super.key,
  });

  final String name;
  final String role;
  final String phone;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE9F1E8),
            child: Icon(icon, color: AppTheme.seed),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  role,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black.withValues(alpha: .56),
                  ),
                ),
              ],
            ),
          ),
          Text(phone, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class SettingsSwitch extends StatefulWidget {
  const SettingsSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;

  @override
  State<SettingsSwitch> createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<SettingsSwitch> {
  late bool value = widget.value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(widget.icon, color: AppTheme.seed),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  widget.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black.withValues(alpha: .56),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (next) => setState(() => value = next),
          ),
        ],
      ),
    );
  }
}
