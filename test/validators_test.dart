import 'package:flutter_test/flutter_test.dart';
import 'package:rolodex/utils/validators.dart';

void main() {
  group('Validators.requiredName', () {
    test('пустая строка — ошибка', () {
      expect(Validators.requiredName('', fieldName: 'имя'), 'Введите имя');
    });

    test('null — ошибка', () {
      expect(Validators.requiredName(null, fieldName: 'имя'), isNotNull);
    });

    test('только пробелы — ошибка', () {
      expect(Validators.requiredName('   ', fieldName: 'имя'), isNotNull);
    });

    test('больше 50 символов — ошибка', () {
      expect(
        Validators.requiredName('а' * 51, fieldName: 'имя'),
        'Не больше 50 символов',
      );
    });

    test('нормальное имя — ок', () {
      expect(Validators.requiredName('Иван', fieldName: 'имя'), isNull);
    });
  });

  group('Validators.phone', () {
    test('пустой — ок (поле необязательное)', () {
      expect(Validators.phone(''), isNull);
    });

    test('буквы "abc" — ошибка', () {
      expect(Validators.phone('abc'), isNotNull);
    });

    test('слишком короткий "123" — ошибка', () {
      expect(Validators.phone('123'), isNotNull);
    });

    test('"+7 (999) 123-45-67" — ок', () {
      expect(Validators.phone('+7 (999) 123-45-67'), isNull);
    });

    test('"89991234567" — ок', () {
      expect(Validators.phone('89991234567'), isNull);
    });
  });

  group('Validators.email', () {
    test('пустой — ок', () {
      expect(Validators.email(''), isNull);
    });

    test('"test@" — ошибка', () {
      expect(Validators.email('test@'), isNotNull);
    });

    test('"test.mail.ru" (без @) — ошибка', () {
      expect(Validators.email('test.mail.ru'), isNotNull);
    });

    test('"te st@mail.ru" (пробел) — ошибка', () {
      expect(Validators.email('te st@mail.ru'), isNotNull);
    });

    test('"test@mail.ru" — ок', () {
      expect(Validators.email('test@mail.ru'), isNull);
    });
  });
}
