import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact_group.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key, required this.group});

  final ContactGroup group;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Contacts')),
      child: SafeArea(
        child: ListView.builder(
          itemCount: group.contacts.length,
          itemBuilder: (context, index) {
            final contact = group.contacts[index];
            return CupertinoListTile(
              title: Text('${contact.firstName} ${contact.lastName}'),
              leading: const Icon(CupertinoIcons.person_2),
            );
          },
        ),
      ),
    );
  }
}
