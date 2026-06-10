import 'package:flutter_test/flutter_test.dart';
import 'package:swadesai_dhruvi/app.dart';

void main() {
  testWidgets('QuickSlot app builds', (tester) async {
    await tester.pumpWidget(const QuickSlotApp());

    expect(
      find.text('QuickSlot — feature structure ready, UI pending'),
      findsOneWidget,
    );
  });
}
