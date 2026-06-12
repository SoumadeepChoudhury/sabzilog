import 'package:flutter/material.dart';

class SettleBalanceSheet extends StatefulWidget {
  const SettleBalanceSheet({
    required this.currentBalance,
    required this.onSettle,
    super.key,
  });

  final int currentBalance;
  final ValueChanged<int> onSettle;

  @override
  State<SettleBalanceSheet> createState() => _SettleBalanceSheetState();
}

class _SettleBalanceSheetState extends State<SettleBalanceSheet> {
  late final TextEditingController _paymentController;

  int get _owedAmount => widget.currentBalance < 0 ? -widget.currentBalance : 0;
  int get _paymentAmount => int.tryParse(_paymentController.text.trim()) ?? 0;
  int get _balanceAfterPayment => widget.currentBalance + _paymentAmount;

  @override
  void initState() {
    super.initState();
    _paymentController = TextEditingController(
      text: _owedAmount > 0 ? '$_owedAmount' : '',
    );
  }

  @override
  void dispose() {
    _paymentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            'Settle balance',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _owedAmount > 0
                ? 'Owner currently owes Rs $_owedAmount. Enter the total amount paid now; extra automatically becomes future advance.'
                : 'No due amount. Enter any amount to add it as future advance.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black.withValues(alpha: .6),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _paymentController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.currency_rupee),
              labelText: 'Amount paid by owner',
              helperText:
                  'The app will settle due first, then keep the rest as advance.',
            ),
          ),
          const SizedBox(height: 14),
          _SettlementPreview(
            currentBalance: widget.currentBalance,
            paymentAmount: _paymentAmount,
            balanceAfterPayment: _balanceAfterPayment,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _paymentAmount > 0
                  ? () {
                      widget.onSettle(_paymentAmount);
                      Navigator.of(context).pop();
                    }
                  : null,
              icon: const Icon(Icons.done_all_outlined),
              label: const Text('Record payment'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettlementPreview extends StatelessWidget {
  const _SettlementPreview({
    required this.currentBalance,
    required this.paymentAmount,
    required this.balanceAfterPayment,
  });

  final int currentBalance;
  final int paymentAmount;
  final int balanceAfterPayment;

  @override
  Widget build(BuildContext context) {
    final dueBeforePayment = currentBalance < 0 ? -currentBalance : 0;
    final settledAmount = paymentAmount.clamp(0, dueBeforePayment);
    final extraAdvance = paymentAmount > dueBeforePayment
        ? paymentAmount - dueBeforePayment
        : 0;
    final label = balanceAfterPayment < 0
        ? 'Still owed'
        : balanceAfterPayment == 0
        ? 'Settled'
        : 'New advance';
    final amount = balanceAfterPayment.abs();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4EA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_outlined, color: Color(0xFF2F6B4F)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Payment Rs $paymentAmount: settles Rs $settledAmount, adds Rs $extraAdvance advance. Status: $label Rs $amount',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black.withValues(alpha: .66),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
