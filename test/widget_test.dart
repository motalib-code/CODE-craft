import 'package:flutter_test/flutter_test.dart';
import 'package:codecraft/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Splash screen shows correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: CodeCraftApp()));

    // Verify that the logo text is shown
    expect(find.text('</>'), findsOneWidget);
    expect(find.text('CodeCraft'), findsOneWidget);
  });
}
