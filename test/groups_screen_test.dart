import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rolodex/data/contacts_repository.dart';
import 'package:rolodex/data/fake_contacts_repository.dart';
import 'package:rolodex/main.dart';

void main() {
  Future<void> pumpGroupsScreen(
    WidgetTester tester,
    ContactsRepository repo, {
    bool settle = true,
  }) async {
    await tester.pumpWidget(RolodexApp(repository: repo));
    if (settle) {
      await tester.pumpAndSettle();
    }
  }

  group('GroupsScreen', () {
    testWidgets('во время загрузки показывает индикатор', (tester) async {
      await pumpGroupsScreen(
        tester,
        FakeContactsRepository(
          delay: const Duration(seconds: 1),
          shouldFail: () => false,
        ),
        settle: false,
      );

      expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      expect(find.text('Друзья'), findsNothing);
      expect(find.text('Повторить'), findsNothing);

      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('при ошибке показывает сообщение и кнопку «Повторить»', (
      tester,
    ) async {
      final repo = FakeContactsRepository(
        delay: Duration.zero,
        shouldFail: () => true,
      );

      await pumpGroupsScreen(tester, repo);

      expect(find.text('Не удалось загрузить контакты'), findsOneWidget);
      expect(find.text('Повторить'), findsOneWidget);
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
      expect(find.text('Друзья'), findsNothing);
    });

    testWidgets('«Повторить» после ошибки загружает и показывает группы', (
      tester,
    ) async {
      var fail = true;
      final repo = FakeContactsRepository(
        delay: Duration.zero,
        shouldFail: () => fail,
      );

      await pumpGroupsScreen(tester, repo);
      expect(find.text('Повторить'), findsOneWidget);

      fail = false;
      await tester.tap(find.text('Повторить'));
      await tester.pumpAndSettle();

      expect(find.text('Не удалось загрузить контакты'), findsNothing);
      expect(find.byType(CupertinoActivityIndicator), findsNothing);
      expect(find.text('Друзья'), findsOneWidget);
    });

    testWidgets('после загрузки показывает группы', (tester) async {
      final repo = FakeContactsRepository(
        delay: Duration.zero,
        shouldFail: () => false,
      );

      await pumpGroupsScreen(tester, repo);

      expect(find.text('Все контакты'), findsOneWidget);
      expect(find.text('Друзья'), findsOneWidget);
      expect(find.text('Работа'), findsOneWidget);
      expect(find.text('51'), findsOneWidget);

      expect(find.byType(CupertinoActivityIndicator), findsNothing);
      expect(find.text('Не удалось загрузить контакты'), findsNothing);
    });
  });
}
