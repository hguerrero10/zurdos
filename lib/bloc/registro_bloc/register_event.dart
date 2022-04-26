// ignore: import_of_legacy_library_into_null_safe
import 'package:equatable/equatable.dart';
// ignore: unused_import
import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RegisterEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged {email: $email}';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged {password: $password}';
}

class NameChanged extends RegisterEvent {
  final String name;

  const NameChanged({required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'NameChanged {name: $name}';
}

class PhoneChanged extends RegisterEvent{
  final String phone;

  const PhoneChanged({required this.phone});

  @override
  List<Object> get props => [phone];

  @override
  String toString() => 'PhoneChanged {phone: $phone}';
}

class SocioChanged extends RegisterEvent {
  final String socio;

  const SocioChanged({required this.socio});

  @override
  List<Object> get props => [socio];

  @override
  String toString() => 'SocioChanged {socio: $socio}';
}

class ImageChanged extends RegisterEvent {
  final String image;

  const ImageChanged({required this.image});

  @override
  List<Object> get props => [image];

  @override
  String toString() => 'ImageChanged {image: $image}';
}

class InsuranceChanged extends RegisterEvent{
  final String insurance;

  const InsuranceChanged({required this.insurance});

  @override
  List<Object> get props => [insurance];

  @override
  String toString() => 'InsuranceChanged {insurance: $insurance}';
}


class TypeBloodChanged extends RegisterEvent {
  final String typeBlood;

  const TypeBloodChanged({required this.typeBlood});

  @override
  List<Object> get props => [typeBlood];

  @override
  String toString() => 'TypeBloodChanged {typeBlood: $typeBlood}';
}

class DateBornChanged extends RegisterEvent {
  final String dateBorn;

  const DateBornChanged({required this.dateBorn});

  @override
  List<Object> get props => [dateBorn];

  @override
  String toString() => 'DateBornChanged {dateBorn: $dateBorn}';
}

class AutoChanged extends RegisterEvent {
  final String auto;

  const AutoChanged({required this.auto});

  @override
  List<Object> get props => [auto];

  @override
  String toString() => 'AutoChanged {auto: $auto}';
}

class UidChanged extends RegisterEvent {
  final String uid;

  const UidChanged({required this.uid});

  @override
  List<Object> get props => [uid];

  @override
  String toString() => 'UidChanged {uid: $uid}';
}

class Submitted extends RegisterEvent {
  
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

  const Submitted({required this.email, required this.password, required this.name, required this.phone, required this.socio, required this.image, required this.insurance, required this.typeBlood,  required this.dateBorn, required this.auto, required this.uid});

  @override
  List<Object> get props => [email, password, name,  phone, socio, image, insurance, typeBlood, dateBorn, auto, uid];

  @override
  String toString() => 'Submitted {email: $email, password: $password, name: $name, phone: $phone, socio: $socio, image: $image, insurance: $insurance, typeBlood: $typeBlood, dateBorn: $dateBorn auto: $auto, uid: $uid}';
}