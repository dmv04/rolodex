import 'dart:math';

import 'package:rolodex/data/contact_group.dart';
import 'package:rolodex/data/contacts_repository.dart';

class FakeContactsRepository implements ContactsRepository {
  FakeContactsRepository({
    this.delay = const Duration(milliseconds: 1500),
    bool Function()? shouldFail,
  }) : _shouldFail = shouldFail ?? (() => _random.nextDouble() < 0.3);

  final Duration delay;
  final bool Function() _shouldFail;
  static final Random _random = Random();

  @override
  Future<List<ContactGroup>> fetchGroups() async {
    await Future.delayed(delay);
    if (_shouldFail()) throw const ContactsLoadException();
    return generateSeedData();
  }
}
