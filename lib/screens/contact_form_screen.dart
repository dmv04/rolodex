import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/app_state.dart';
import 'package:rolodex/utils/validators.dart';

import '../data/contact.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        middle: const Text('Новый контакт'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: const Text('Готово'),
        ),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              CupertinoFormSection(
                header: const Text('Имя'),
                children: [
                  CupertinoTextFormFieldRow(
                    controller: _firstNameController,
                    prefix: const Text('Имя'),
                    placeholder: 'Обязательно',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        Validators.requiredName(value, fieldName: 'имя'),
                  ),
                  CupertinoTextFormFieldRow(
                    controller: _lastNameController,
                    prefix: const Text('Фамилия'),
                    placeholder: 'Обязательно',
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        Validators.requiredName(value, fieldName: 'фамилию'),
                  ),
                ],
              ),
              CupertinoFormSection(
                header: const Text('Контактная информация'),
                children: [
                  CupertinoTextFormFieldRow(
                    controller: _phoneController,
                    prefix: const Text('Телефон'),
                    placeholder: '+7 999 123-45-67',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                  ),
                  CupertinoTextFormFieldRow(
                    controller: _emailController,
                    prefix: const Text('Email'),
                    placeholder: 'name@example.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    String? orNull(String text) => text.trim().isEmpty ? null : text.trim();

    final contact = Contact(
      id: contactGroupsModel.nextContactId(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: orNull(_phoneController.text),
      email: orNull(_emailController.text),
    );

    Navigator.of(context).pop(contact);
  }
}
