// ignore: import_of_legacy_library_into_null_safe
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:santiago4x4pro/models/user_model.dart';

@immutable
abstract class UserState extends Equatable {
  const UserState([List props = const []]) : super(props);
}

class UserLoading extends UserState {
  @override
  String toString() => 'UserLoading';
}

class UserLoaded extends UserState {
  final List<UserModel> users;

  UserLoaded([this.users = const []]) : super([users]);

  @override
  String toString() => 'TodosLoaded { users: $users }';
}

class UsersNotLoaded extends UserState {
  @override
  String toString() => 'UsersNotLoaded';
}
