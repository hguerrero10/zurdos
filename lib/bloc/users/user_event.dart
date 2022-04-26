// ignore: import_of_legacy_library_into_null_safe
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:santiago4x4pro/models/user_model.dart';

@immutable
abstract class UserEvent extends Equatable {
  const UserEvent([List props = const []]) : super(props);
}

class LoadUser extends UserEvent {
  @override
  String toString() => 'LoadUsers';
}

class AddUser extends UserEvent {
  final String email;
  final String password;
  final String name;
  final String phone;
  final String socio;
  final String image;
  final String insurance;
  final String typeBlood;
  final String dateBorn;
  final String auto;
  final String uid;

  AddUser(this.email, this.password,this.name, this.phone, this.socio, this.image, this.insurance, this.typeBlood, this.dateBorn, this.auto, this.uid) : super([email, password,  name, phone, socio, image, insurance, typeBlood, dateBorn, auto, uid]);

  @override
  String toString() => 'AddUser {  email: $email, password: $password, name: $name, phone: $phone, socio: $socio, image: $image, insurance: $insurance, typeBlood: $typeBlood, dateBorn: $dateBorn, auto: $auto, uid: $uid} ';
}

class UpdateUser extends UserEvent {
  final UserModel updatedUser;

  UpdateUser(this.updatedUser) : super([updatedUser]);

  @override
  String toString() => 'UpdateUser { updatedUser: $updatedUser }';
}

class DeleteUser extends UserEvent {
  final UserModel user;

  DeleteUser(this.user) : super([user]);

  @override
  String toString() => 'DeleteUser { user: $user }';
}

class UsersUpdated extends UserEvent {
  final List<UserModel> users;

  const UsersUpdated(this.users);

  @override
  String toString() => 'UsersUpdated';
}

