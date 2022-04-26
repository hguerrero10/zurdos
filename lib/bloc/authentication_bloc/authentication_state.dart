// ignore: import_of_legacy_library_into_null_safe
import 'package:equatable/equatable.dart';
import 'package:santiago4x4pro/models/user_model.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState([List props = const [] ]) : super(props);
}

class Uninitialized extends AuthenticationState{
  @override
  String toString() => 'No inicializado';
}

class Authenticated extends AuthenticationState {
final UserModel user;

  Authenticated(this.user) : super([user]);

  @override
  String toString() => 'Authenticated { User: $user }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'No autenticado';
}