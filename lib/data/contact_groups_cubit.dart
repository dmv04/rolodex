import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolodex/data/contact.dart';
import 'package:rolodex/data/contact_group.dart';
import 'package:rolodex/data/contact_groups_state.dart';
import 'package:rolodex/data/contacts_repository.dart';

class ContactGroupsCubit extends Cubit<ContactGroupsState> {
  ContactGroupsCubit(this._repository) : super(const ContactGroupsLoading());

  final ContactsRepository _repository;

  Future<void> loadContactGroups() async {
    emit(const ContactGroupsLoading());
    try {
      final groups = await _repository.fetchGroups();
      if (isClosed) return;
      emit(ContactGroupsLoaded(groups));
    } on ContactsLoadException {
      if (isClosed) return;
      emit(const ContactGroupsError('Не удалось загрузить контакты'));
    }
  }

  void addContact(Contact contact, {required int groupId}) {
    final current = state;
    if (current is! ContactGroupsLoaded) return;

    final updated = [
      for (final group in current.groups)
        if (group.id == 0 || group.id == groupId)
          ContactGroup(
            id: group.id,
            label: group.label,
            title: group.title,
            permanent: group.permanent,
            contacts: [...group.contacts, contact],
          )
        else
          group,
    ];
    emit(ContactGroupsLoaded(updated));
  }

  int nextContactId() {
    final current = state;
    if (current is! ContactGroupsLoaded) return 0;

    final allContactsList = current.groups.first.contacts;
    if (allContactsList.isEmpty) return 0;
    return allContactsList.map((c) => c.id).reduce(max) + 1;
  }
}
