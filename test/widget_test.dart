import 'package:flutter_test/flutter_test.dart';

import 'package:figma/app/app.dart';

void main() {
  testWidgets('renders home splash screen', (tester) async {
    await tester.pumpWidget(const ExpenseAssistantApp());
    await tester.pump();

    expect(find.text('Wallet Manager'), findsOneWidget);
    expect(find.text('YOUR DIGITAL PRIVATE BANK'), findsOneWidget);
    expect(find.text('SECURING WORKSPACE'), findsOneWidget);
  });
}
