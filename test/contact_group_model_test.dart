import 'package:flutter_test/flutter_test.dart';
import 'package:rolodex/data/contact.dart';
import 'package:rolodex/data/contact_group.dart';

void main() {
  late ContactGroupsModel model;

  setUp(() {
    model = ContactGroupsModel();
  });

  tearDown(() {
    model.dispose();
  });

  Contact newContact(int id) =>
      Contact(id: id, firstName: 'Иван', lastName: 'Иванов');

  test('nextContactId — на 1 больше максимального', () {
    expect(model.nextContactId(), 51);
  });

  test('контакт попадает в «Все контакты» и в выбранную группу', () {
    final allBefore = model.findContactList(0).contacts.length;
    final friendsBefore = model.findContactList(1).contacts.length;

    model.addContact(newContact(51), groupId: 1);

    expect(model.findContactList(0).contacts, hasLength(allBefore + 1));
    expect(model.findContactList(1).contacts, hasLength(friendsBefore + 1));
  });

  test('другие группы не меняются', () {
    final otherGroupBefore = model.findContactList(2).contacts.length;

    model.addContact(newContact(51), groupId: 1);

    expect(model.findContactList(2).contacts, hasLength(otherGroupBefore));
  });

  test('добавление в «Все контакты» не дублирует контакт', () {
    final allBefore = model.findContactList(0).contacts.length;

    model.addContact(newContact(51), groupId: 0);

    expect(model.findContactList(0).contacts, hasLength(allBefore + 1));
  });

  test('слушатели получают уведомление', () {
    var notified = 0;
    model.listsNotifier.addListener(() => notified++);

    model.addContact(newContact(51), groupId: 1);

    expect(notified, 1);
  });
}
