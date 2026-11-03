import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact.dart';

class ContactDetailScreen extends StatelessWidget {
  const ContactDetailScreen({super.key, required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [_buildHeader(), _buildActionRow(), _buildFieldsSection()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: CupertinoColors.systemGrey4,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              contact.initials,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          contact.fullName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: CupertinoIcons.phone_fill,
              label: 'звонок',
              onTap: () {},
            ),
          ),
          Expanded(
            child: _ActionButton(
              icon: CupertinoIcons.chat_bubble_fill,
              label: 'сообщение',
              onTap: () {},
            ),
          ),
          Expanded(
            child: _ActionButton(
              icon: CupertinoIcons.mail_solid,
              label: 'почта',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsSection() {
    return CupertinoListSection.insetGrouped(
      header: const Text('ИНФОРМАЦИЯ'),
      children: [
        CupertinoListTile(
          title: const Text('Имя'),
          additionalInfo: Text(contact.firstName),
        ),
        if (contact.middleName != null && contact.middleName!.isNotEmpty)
          CupertinoListTile(
            title: const Text('Отчество'),
            additionalInfo: Text(contact.middleName!),
          ),
        CupertinoListTile(
          title: const Text('Фамилия'),
          additionalInfo: Text(contact.lastName),
        ),
        if (contact.suffix != null && contact.suffix!.isNotEmpty)
          CupertinoListTile(
            title: const Text('Суффикс'),
            additionalInfo: Text(contact.suffix!),
          ),
        if (contact.phone != null)
          CupertinoListTile(
            title: const Text('Телефон'),
            additionalInfo: Text(contact.phone!),
          ),
        if (contact.email != null)
          CupertinoListTile(
            title: const Text('Email'),
            additionalInfo: Text(contact.email!),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
