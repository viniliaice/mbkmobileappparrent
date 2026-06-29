import 'package:flutter_test/flutter_test.dart';
import 'package:mbk_parent_portal/main.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MBKParentPortalApp());
    expect(find.byType(MBKParentPortalApp), findsOneWidget);
  });
}
