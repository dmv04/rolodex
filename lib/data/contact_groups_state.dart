import 'package:equatable/equatable.dart';
import 'package:rolodex/data/contact_group.dart';

sealed class ContactGroupsState extends Equatable {
  const ContactGroupsState();
  @override
  List<Object?> get props => const [];
}

final class ContactGroupsLoading extends ContactGroupsState {
  const ContactGroupsLoading();
}

final class ContactGroupsLoaded extends ContactGroupsState {
  const ContactGroupsLoaded(this.groups);
  final List<ContactGroup> groups;
}

final class ContactGroupsError extends ContactGroupsState {
  const ContactGroupsError(this.message);
  final String message;
}
