class Validators {
  static String? requiredName(String? value, {required String fieldName}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Введите $fieldName';
    if (text.length > 50) return 'Не больше 50 символов';
    return null;
  }

  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null; // поле необязательное
    if (!RegExp(r'^\+?[0-9\s\-()]+$').hasMatch(text)) {
      return 'Только цифры, пробелы, + - ( )';
    }
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 15) {
      return 'От 10 до 15 цифр';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null; // поле необязательное
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
      return 'Неверный формат email';
    }
    return null;
  }
}
