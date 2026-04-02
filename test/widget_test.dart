import 'package:flutter_test/flutter_test.dart';
import 'package:ecotrack/main.dart';

void main() {
  testWidgets('App starts up', (WidgetTester tester) async {
    await tester.pumpWidget(const EcoTrackApp());
  });
}
