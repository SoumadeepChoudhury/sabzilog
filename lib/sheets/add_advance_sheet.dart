import 'package:flutter/material.dart';

class AddAdvanceSheet extends StatefulWidget {
  const AddAdvanceSheet({required this.onAdd, super.key});

  final ValueChanged<int> onAdd;

  @override
  State<AddAdvanceSheet> createState() => _AddAdvanceSheetState();
}

class _AddAdvanceSheetState extends State<AddAdvanceSheet> {
  final _controller = TextEditingController(text: '500');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add advance',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.currency_rupee),
                labelText: 'Amount given',
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final amount = int.tryParse(_controller.text.trim()) ?? 0;
                  if (amount > 0) widget.onAdd(amount);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.add_card_outlined),
                label: const Text('Add to balance'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
