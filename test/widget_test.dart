// Basic smoke test for GreenCart app

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_cart/app.dart';

void main() {
  testWidgets('GreenCart app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: GreenCartApp()),
    );

    // Verify app launches with GreenCart title on splash screen
    expect(find.text('GreenCart'), findsOneWidget);
  });
}
