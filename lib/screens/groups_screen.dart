import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact_group.dart';
import 'package:rolodex/data/app_state.dart';
import 'package:rolodex/widgets/group_tile.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Lists')),
      child: SafeArea(
        child: ValueListenableBuilder<List<ContactGroup>>(
          valueListenable: contactGroupsModel.listsNotifier,
          builder: (context, groups, _) {
            return ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  children: groups
                      .where((g) => g.permanent)
                      .map((g) => GroupTile(group: g, onTap: () {}))
                      .toList(),
                ),
                CupertinoListSection.insetGrouped(
                  header: const Text('My Lists'),
                  children: groups
                      .where((g) => !g.permanent)
                      .map((g) => GroupTile(group: g, onTap: () {}))
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
