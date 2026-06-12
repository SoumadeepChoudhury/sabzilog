import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/app.dart';

void main() {
  testWidgets('renders login and opens maid dashboard by default', (
    tester,
  ) async {
    await tester.pumpWidget(const VegLogApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sabzi Log'), findsOneWidget);
    expect(find.text('Login as Maid'), findsOneWidget);

    await tester.tap(find.text('Login as Maid'));
    await tester.pumpAndSettle();

    expect(find.text('Add purchase in seconds'), findsOneWidget);
    expect(find.text('Capture purchase'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('owner role opens owner dashboard', (tester) async {
    await tester.pumpWidget(const VegLogApp());

    await tester.tap(find.text('Owner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login as Owner'));
    await tester.pumpAndSettle();

    expect(find.text('Owner owes maid'), findsOneWidget);
    expect(find.text('Owner review'), findsOneWidget);
    expect(
      find.text('Clear due or include extra future advance.'),
      findsOneWidget,
    );
    expect(find.text('Balance'), findsOneWidget);
    expect(find.byIcon(Icons.add_card_outlined), findsNothing);
  });

  testWidgets('expense log filters update visible entries', (tester) async {
    await tester.pumpWidget(const VegLogApp());

    await tester.tap(find.text('Owner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login as Owner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    expect(find.text('Tomato, beans'), findsOneWidget);
    expect(find.text('Potato, onion'), findsOneWidget);
    expect(find.text('Coriander'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Pending'));
    await tester.pumpAndSettle();
    expect(find.text('Tomato, beans'), findsNothing);
    expect(find.text('Potato, onion'), findsOneWidget);
    expect(find.text('Coriander'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Questions'));
    await tester.pumpAndSettle();
    expect(find.text('Potato, onion'), findsNothing);
    expect(find.text('Coriander'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Checked'));
    await tester.pumpAndSettle();
    expect(find.text('Tomato, beans'), findsOneWidget);
    expect(find.text('Coriander'), findsNothing);
  });

  testWidgets('settlement sheet uses one payment field', (tester) async {
    await tester.pumpWidget(const VegLogApp());

    await tester.tap(find.text('Owner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login as Owner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settle due'));
    await tester.pumpAndSettle();

    expect(find.text('Amount paid by owner'), findsOneWidget);
    expect(find.text('Pay against due'), findsNothing);
    expect(find.text('Extra future advance'), findsNothing);
    expect(find.textContaining('settles Rs 80'), findsOneWidget);
  });

  testWidgets('owner balance page shows monthly report', (tester) async {
    await tester.pumpWidget(const VegLogApp());

    await tester.tap(find.text('Owner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login as Owner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Balance').last);
    await tester.pumpAndSettle();
    final balanceScroll = find
        .descendant(
          of: find.byKey(const ValueKey('balance_page_scroll')),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('Monthly report'),
      300,
      scrollable: balanceScroll,
    );

    expect(find.text('Monthly report'), findsOneWidget);
    expect(find.text('Money flow for May'), findsOneWidget);
    expect(find.text('Given by owner'), findsOneWidget);
    expect(find.text('Spent by maid'), findsOneWidget);
    expect(find.text('Owner owes'), findsOneWidget);
    expect(find.text('Category split'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Owner actions'),
      300,
      scrollable: balanceScroll,
    );
    expect(find.text('Owner actions'), findsOneWidget);
  });
}
