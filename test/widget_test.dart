import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/main.dart';

void main() {
  testWidgets('Auralis app renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AuralisApp(),
      ),
    );
    expect(find.byType(AuralisApp), findsOneWidget);
  });
}
