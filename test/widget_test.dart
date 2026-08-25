import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MusicApp());
    await tester.pumpAndSettle();

    expect(find.text('Vibes'), findsOneWidget);
    expect(find.text('Featured'), findsOneWidget);
    expect(find.text('All Tracks'), findsOneWidget);
  });
}
