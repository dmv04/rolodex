import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact_group.dart';
import 'package:rolodex/data/app_state.dart';
import 'package:rolodex/widgets/group_tile.dart';
import 'package:rolodex/screens/contacts_screen.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Списки')),
      child: SafeArea(
        child: ValueListenableBuilder<List<ContactGroup>>(
          valueListenable: contactGroupsModel.listsNotifier,
          builder: (context, groups, _) {
            return ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  children: groups
                      .where((g) => g.permanent)
                      .map(
                        (g) => GroupTile(
                          group: g,
                          onTap: () => _openGroup(context, g),
                        ),
                      )
                      .toList(),
                ),
                CupertinoListSection.insetGrouped(
                  header: const Text('Мои списки'),
                  children: groups
                      .where((g) => !g.permanent)
                      .map(
                        (g) => GroupTile(
                          group: g,
                          onTap: () => _openGroup(context, g),
                        ),
                      )
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void _openGroup(BuildContext context, ContactGroup group) {
  Navigator.of(context).push(
    CupertinoPageRoute(
      title: group.title,
      builder: (_) => ContactsScreen(groupId: group.id),
    ),
  );
}
