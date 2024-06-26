part of 'add_group_bloc.dart';

@immutable
sealed class AddGroupEvent extends Equatable {
  const AddGroupEvent();

  @override
  List<Object> get props => [];
}

final class GroupNameChanged extends AddGroupEvent {
  const GroupNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

final class SearchForUsers extends AddGroupEvent {
  const SearchForUsers();
}

final class SelectUser extends AddGroupEvent {
  const SelectUser(this.user);

  final UserAccount user;

  @override
  List<Object> get props => [user];
}

final class DeselectUser extends AddGroupEvent {
  const DeselectUser(this.userId);

  final String userId;

  @override
  List<Object> get props => [userId];
}

final class CreateGroup extends AddGroupEvent {
  const CreateGroup();
}

final class ResetDialog extends AddGroupEvent {
  const ResetDialog();
}