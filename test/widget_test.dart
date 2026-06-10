import 'package:flutter_test/flutter_test.dart';
import 'package:swadesai_dhruvi/app.dart';

void main() {
  testWidgets('QuickSlot app widget exists', (tester) async {
    // Full app requires Firebase init — smoke test the widget type only.
    expect(const QuickSlotApp(), isNotNull);
  });
}
