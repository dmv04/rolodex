import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact_group.dart';

class GroupTile extends StatelessWidget {
  const GroupTile({super.key, required this.group, required this.onTap});

  final ContactGroup group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(group.label),
      leading: const Icon(CupertinoIcons.person_2),
      additionalInfo: Text('${group.contacts.length}'),
      trailing: const CupertinoListTileChevron(),
      onTap: () {
        Navigator.of(context)
            .push(CupertinoPageRoute(builder: (_) => ContactsScreen(group: g)));
      },
    );
  }
}
