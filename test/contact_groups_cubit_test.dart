import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rolodex/data/contact.dart';
import 'package:rolodex/data/contact_group.dart';
import 'package:rolodex/data/contact_groups_cubit.dart';
import 'package:rolodex/data/contact_groups_state.dart';
import 'package:rolodex/data/fake_contacts_repository.dart';

void main() {
  ContactGroupsCubit buildCubit({bool fail = false}) => ContactGroupsCubit(
    FakeContactsRepository(delay: Duration.zero, shouldFail: () => fail),
  );

  const errorState = ContactGroupsError('Не удалось загрузить контакты');

  test('начальное состояние — Loading', () async {
    final cubit = buildCubit();
    expect(cubit.state, const ContactGroupsLoading());
    await cubit.close();
  });

  group('loadContactGroups', () {
    blocTest<ContactGroupsCubit, ContactGroupsState>(
      'успешная загрузка: Loading, затем данные',
      build: buildCubit,
      act: (cubit) => cubit.loadContactGroups(),
      expect: () => [
        const ContactGroupsLoading(),
        ContactGroupsLoaded(generateSeedData()),
      ],
    );

    blocTest<ContactGroupsCubit, ContactGroupsState>(
      'ошибка загрузки: Loading, затем понятное сообщение',
      build: () => buildCubit(fail: true),
      act: (cubit) => cubit.loadContactGroups(),
      expect: () => [const ContactGroupsLoading(), errorState],
    );

    blocTest<ContactGroupsCubit, ContactGroupsState>(
      'повтор после ошибки показывает загрузку, затем данные',
      build: buildCubit,
      seed: () => errorState,
      act: (cubit) => cubit.loadContactGroups(),
      expect: () => [
        const ContactGroupsLoading(),
        ContactGroupsLoaded(generateSeedData()),
      ],
    );

    for (final fail in [false, true]) {
      test('не эмитит состояние, если cubit закрыли во время загрузки '
          '(${fail ? 'ошибка' : 'успех'})', () async {
        final cubit = buildCubit(fail: fail);
        final loading = cubit.loadContactGroups();
        await cubit.close();
        await loading;
        expect(cubit.state, const ContactGroupsLoading());
      });
    }
  });

  group('addContact', () {
    final newContact = Contact(id: 51, firstName: 'Иван', lastName: 'Иванов');

    blocTest<ContactGroupsCubit, ContactGroupsState>(
      'добавляет контакт в «Все контакты» и выбранную группу',
      build: buildCubit,
      seed: () => ContactGroupsLoaded(generateSeedData()),
      act: (cubit) => cubit.addContact(newContact, groupId: 1),
      expect: () => [
        isA<ContactGroupsLoaded>()
            .having(
              (s) => s.groups[0].contacts,
              'все контакты',
              contains(newContact),
            )
            .having((s) => s.groups[1].contacts, 'друзья', contains(newContact))
            .having(
              (s) => s.groups[2].contacts,
              'работа',
              isNot(contains(newContact)),
            ),
      ],
    );

    blocTest<ContactGroupsCubit, ContactGroupsState>(
      'ничего не делает, пока данные не загружены',
      build: buildCubit,
      act: (cubit) => cubit.addContact(newContact, groupId: 1),
      expect: () => <ContactGroupsState>[],
    );
  });

  group('nextContactId', () {
    blocTest<ContactGroupsCubit, ContactGroupsState>(
      'возвращает максимальный id + 1',
      build: buildCubit,
      seed: () => ContactGroupsLoaded(generateSeedData()),
      verify: (cubit) => expect(cubit.nextContactId(), 51),
    );

    blocTest<ContactGroupsCubit, ContactGroupsState>(
      'возвращает 0, если контактов нет',
      build: buildCubit,
      seed: () => ContactGroupsLoaded([ContactGroup(id: 0, label: 'Все')]),
      verify: (cubit) => expect(cubit.nextContactId(), 0),
    );

    test('возвращает 0, пока данные не загружены', () async {
      final cubit = buildCubit();
      expect(cubit.nextContactId(), 0);
      await cubit.close();
    });
  });
}
