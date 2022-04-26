import 'dart:async';
// ignore: import_of_legacy_library_into_null_safe
import 'package:bloc/bloc.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository}) : _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
    if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    }
    if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser(await _userRepository.getUserId());
        yield await Future.delayed(const Duration(seconds: 5), () {
          return Authenticated(user);
        });
      }
      else {
        yield await Future.delayed(const Duration(seconds: 5), () {
          return Unauthenticated();
        });
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await _userRepository.getUser(await _userRepository.getUserId()));
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}