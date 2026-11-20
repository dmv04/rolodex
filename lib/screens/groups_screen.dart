import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolodex/data/contact_group.dart';
import 'package:rolodex/data/contact_groups_cubit.dart';
import 'package:rolodex/data/contact_groups_state.dart';
import 'package:rolodex/screens/contacts_screen.dart';
import 'package:rolodex/widgets/group_tile.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Списки')),
      child: SafeArea(
        child: BlocBuilder<ContactGroupsCubit, ContactGroupsState>(
          builder: (context, state) => switch (state) {
            ContactGroupsLoading() => const Center(
              child: CupertinoActivityIndicator(),
            ),
            ContactGroupsError(:final message) => _ErrorView(
              message: message,
              onRetry: () =>
                  context.read<ContactGroupsCubit>().loadContactGroups(),
            ),
            ContactGroupsLoaded(:final groups) => _GroupsList(groups: groups),
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          CupertinoButton.filled(
            onPressed: onRetry,
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}

class _GroupsList extends StatelessWidget {
  const _GroupsList({required this.groups});

  final List<ContactGroup> groups;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CupertinoListSection.insetGrouped(
          children: [
            for (final g in groups.where((g) => g.permanent))
              GroupTile(group: g, onTap: () => _openGroup(context, g)),
          ],
        ),
        CupertinoListSection.insetGrouped(
          header: const Text('Мои списки'),
          children: [
            for (final g in groups.where((g) => !g.permanent))
              GroupTile(group: g, onTap: () => _openGroup(context, g)),
          ],
        ),
      ],
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
