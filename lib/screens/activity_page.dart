import 'package:flutter/material.dart';
import 'package:logger/models/user_role.dart';

import '../models/veg_entry.dart';
import '../widgets/app_widgets.dart';

enum ExpenseFilter { all, pending, questions, checked }

class ActivityPage extends StatefulWidget {
  const ActivityPage({
    required this.entries,
    required this.isLoading,
    required this.setInitialLogs,
    required this.role,
    super.key,
  });

  final List<VegEntry> entries;
  final bool isLoading;
  final UserRole role;
  final void Function() setInitialLogs;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  ExpenseFilter _selectedFilter = ExpenseFilter.all;

  List<VegEntry> get _filteredEntries {
    return widget.entries.where((entry) {
      switch (_selectedFilter) {
        case ExpenseFilter.all:
          return true;
        case ExpenseFilter.pending:
          return entry.status == LogStatus.pending;
        case ExpenseFilter.questions:
          return entry.status == LogStatus.question;
        case ExpenseFilter.checked:
          return entry.status == LogStatus.accepted;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = _filteredEntries;

    return RefreshIndicator(
      onRefresh: () async {
        widget.setInitialLogs();
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
        children: [
          Text(
            'Expense logs',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search by item, date, amount',
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterPill(
                  label: 'All',
                  selected: _selectedFilter == ExpenseFilter.all,
                  onSelected: () => _selectFilter(ExpenseFilter.all),
                ),
                FilterPill(
                  label: 'Pending',
                  selected: _selectedFilter == ExpenseFilter.pending,
                  onSelected: () => _selectFilter(ExpenseFilter.pending),
                ),
                FilterPill(
                  label: 'Questions',
                  selected: _selectedFilter == ExpenseFilter.questions,
                  onSelected: () => _selectFilter(ExpenseFilter.questions),
                ),
                FilterPill(
                  label: 'Checked',
                  selected: _selectedFilter == ExpenseFilter.checked,
                  onSelected: () => _selectFilter(ExpenseFilter.checked),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (filteredEntries.isEmpty)
            const EmptyLogState()
          else
            ...filteredEntries.map((e) => EntryTile(e, widget.role)),
        ],
      ),
    );
  }

  void _selectFilter(ExpenseFilter filter) {
    setState(() => _selectedFilter = filter);
  }
}
