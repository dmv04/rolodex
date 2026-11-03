import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rolodex/main.dart';

void main() {
  testWidgets('добавление контакта в «Друзья»', (tester) async {
    await tester.pumpWidget(const RolodexApp());

    await tester.tap(find.text('Друзья'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(CupertinoIcons.add));
    await tester.pumpAndSettle();

    final fields = find.byType(CupertinoTextField);
    await tester.enterText(fields.at(0), 'Иван');
    await tester.enterText(fields.at(1), 'Иванов');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Готово'));
    await tester.pumpAndSettle();

    expect(find.text('Иван Иванов'), findsOneWidget);
  });
}