// ignore: import_of_legacy_library_into_null_safe
import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent([List props = const []]) : super(props);

}

class AppStarted extends AuthenticationEvent{
    @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent{
    @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthenticationEvent{
    @override
  String toString() => 'LoggedOut';
}