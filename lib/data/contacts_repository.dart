import 'package:rolodex/data/contact_group.dart';

abstract class ContactsRepository {
  Future<List<ContactGroup>> fetchGroups();
}

class ContactsLoadException implements Exception {
  const ContactsLoadException([this.message = 'Failed to load contacts']);
  final String message;

  @override
  String toString() => 'ContactsLoadException: $message';
}
