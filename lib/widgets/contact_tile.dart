import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({super.key, required this.contact, required this.onTap});

  final Contact contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      leading: const Icon(
        CupertinoIcons.person_crop_circle_fill,
        color: CupertinoColors.systemGrey,
      ),
      title: Text(contact.fullName),
      onTap: onTap,
    );
  }
}
