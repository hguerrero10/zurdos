// ignore: import_of_legacy_library_into_null_safe
import 'package:bloc/bloc.dart';
import 'dart:async';
// ignore: unused_import
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/util/validators.dart';

import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    TransitionFunction<LoginEvent, LoginState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if(event is EmailChanged){
      yield* _mapEmailChangedToState(event.email);
    }
    if(event is PasswordChanged){
      yield* _mapPasswordChangedToState(event.password);
    }
    if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async*{
    yield state.update(
      isEmailValid: Validators.isValidEmail(email)
    );
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async*{
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password)
    );
  } 

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    required String email, required String password
  }) async* {
    yield LoginState.loading();
    try {
      await _userRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
