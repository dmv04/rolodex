import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rolodex/screens/contact_form_screen.dart';
import 'package:rolodex/data/contact.dart';

void main() {
  final fields = find.byType(CupertinoTextFormFieldRow);

  Future<void> openForm(WidgetTester tester) async {
    await tester.pumpWidget(const CupertinoApp(home: ContactFormScreen()));
  }

  testWidgets('пустая форма: ошибки под именем и фамилией', (tester) async {
    await openForm(tester);

    await tester.tap(find.text('Готово'));
    await tester.pump();

    expect(find.text('Введите имя'), findsOneWidget);
    expect(find.text('Введите фамилию'), findsOneWidget);
  });

  testWidgets('неверный email: ошибка', (tester) async {
    await openForm(tester);

    await tester.enterText(fields.at(3), 'test@');
    await tester.pump();

    expect(find.text('Неверный формат email'), findsOneWidget);
  });

  testWidgets('неверный телефон: ошибка', (tester) async {
    // 1. Сначала монтируем виджет и открываем форму
    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (context) => CupertinoButton(
            child: const Text('open'),
            onPressed: () async {
              await Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => const ContactFormScreen()),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(CupertinoTextField).at(2), 'abc');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Готово'));
    await tester.pumpAndSettle();

    expect(find.text('Только цифры, пробелы, + - ( )'), findsOneWidget);
  });

  testWidgets('корректная форма возвращает контакт', (tester) async {
    Contact? result;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (context) => CupertinoButton(
            child: const Text('open'),
            onPressed: () async {
              result = await Navigator.of(context).push<Contact>(
                CupertinoPageRoute(builder: (_) => const ContactFormScreen()),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(fields.at(0), 'Иван');
    await tester.enterText(fields.at(1), 'Иванов');
    await tester.enterText(fields.at(3), 'ivan@mail.ru');

    await tester.tap(find.text('Готово'));
    await tester.pumpAndSettle();

    expect(find.byType(ContactFormScreen), findsNothing);
    expect(result, isNotNull);
    expect(result!.firstName, 'Иван');
    expect(result!.lastName, 'Иванов');
    expect(result!.email, 'ivan@mail.ru');
    expect(result!.phone, isNull);
  });

  testWidgets('«Отмена» возвращает null', (tester) async {
    Contact? result;

    await tester.pumpWidget(
      CupertinoApp(
        home: Builder(
          builder: (context) => CupertinoButton(
            child: const Text('open'),
            onPressed: () async {
              result = await Navigator.of(context).push<Contact>(
                CupertinoPageRoute(builder: (_) => const ContactFormScreen()),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();

    expect(find.byType(ContactFormScreen), findsNothing);
    expect(result, isNull);
  });
}
