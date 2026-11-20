import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolodex/data/contact_groups_cubit.dart';
import 'package:rolodex/data/contacts_repository.dart';
import 'package:rolodex/data/fake_contacts_repository.dart';
import 'package:rolodex/screens/groups_screen.dart';

void main() {
  runApp(RolodexApp(repository: FakeContactsRepository()));
}

class RolodexApp extends StatelessWidget {
  const RolodexApp({super.key, required this.repository});

  final ContactsRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactGroupsCubit(repository)..loadContactGroups(),
      child: const CupertinoApp(
        title: 'Rolodex',
        theme: CupertinoThemeData(
          barBackgroundColor: CupertinoDynamicColor.withBrightness(
            color: Color(0xFFF9F9F9),
            darkColor: Color(0xFF1D1D1D),
          ),
        ),
        home: GroupsScreen(),
      ),
    );
  }
}
