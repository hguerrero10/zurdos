// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'bloc.dart';
import 'package:santiago4x4pro/bloc/users/bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _usersRepository;
  late final StreamSubscription _usersSubscription;

  UserBloc({required UserRepository usersRepository}) : _usersRepository = usersRepository;

  @override
  UserState get initialState => UserLoading();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is LoadUser) {
      yield* _mapLoadUserToState();
    } else if (event is AddUser) {
      yield* _mapAddUserToState(event);
    } else if (event is UpdateUser) {
      yield* _mapUpdateUserToState(event);
    } else if (event is UsersUpdated) {
      yield* _mapUsersUpdatedToState(event);
    }
  }

Stream<UserState> _mapLoadUserToState() async* {
    _usersSubscription.cancel();
    _usersSubscription = _usersRepository.users().listen(
      (users) {
        add(
          UsersUpdated(users),
        );
      },
    );
  }

  Stream<UserState> _mapAddUserToState(AddUser event) async* {
    _usersRepository.signUp(event.email, event.password,  event.name, event.phone, event.socio, event.image, event.insurance, event.typeBlood, event.dateBorn, event.auto, event. uid);
  }

  Stream<UserState> _mapUpdateUserToState(UpdateUser event) async* {
    _usersRepository.updateUsers(event.updatedUser);
  }


  Stream<UserState> _mapUsersUpdatedToState(UsersUpdated event) async* {
    yield UserLoaded(event.users);
  }

  void dispose() {
    _usersSubscription.cancel();
    super.close();
  }
}
