import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact_group.dart';
import 'package:rolodex/data/app_state.dart';
import 'package:rolodex/widgets/contact_tile.dart';
import 'package:rolodex/screens/contact_detail_screen.dart';

import 'package:rolodex/data/contact.dart';
import 'package:rolodex/screens/contact_form_screen.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key, required this.groupId});

  final int groupId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ContactGroup>>(
      valueListenable: contactGroupsModel.listsNotifier,
      builder: (context, _, _) {
        final group = contactGroupsModel.findContactList(groupId);

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(group.title),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _addContact(context),
              child: const Icon(CupertinoIcons.add),
            ),
          ),
          child: SafeArea(
            child: group.contacts.isEmpty
                ? const Center(child: Text('Нет контактов'))
                : ListView(
                    children: [
                      for (final entry in group.alphabetizedContacts.entries)
                        CupertinoListSection(
                          header: Text(entry.key),
                          children: [
                            for (final contact in entry.value)
                              ContactTile(
                                contact: contact,
                                onTap: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (_) =>
                                          ContactDetailScreen(contact: contact),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Future<void> _addContact(BuildContext context) async {
    final contact = await Navigator.of(context).push<Contact>(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => const ContactFormScreen(),
      ),
    );

    if (contact != null) {
      contactGroupsModel.addContact(contact, groupId: groupId);
    }
  }
}
