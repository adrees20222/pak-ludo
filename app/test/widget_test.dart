import 'package:flutter_test/flutter_test.dart';
import 'package:pak_ludo/main.dart';

void main() {
  testWidgets('Pak Ludo loads home screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PakLudoApp());
    await tester.pumpAndSettle();

    expect(find.text('Play Now!'), findsOneWidget);
    expect(find.text('Rules'), findsOneWidget);
    expect(find.text('Instant Play'), findsOneWidget);
  });
}

