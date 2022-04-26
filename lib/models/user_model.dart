import 'package:santiago4x4pro/entity/user_entity.dart';

class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String socio;
  final String image;
  final String insurance;
  final String dateBorn;
  final String typeBlood;
  final String auto;

  UserModel(this.email, this.name, this.phone, this.socio, this.image, this.insurance, this.dateBorn, this.typeBlood, this.auto, this.uid);

  @override
  int get hashCode => uid.hashCode ^ email.hashCode ^  name.hashCode  ^ phone.hashCode ^ socio.hashCode ^ image.hashCode ^ insurance.hashCode ^ dateBorn.hashCode ^ typeBlood.hashCode ^ auto.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) ||
    other is UserModel &&
    runtimeType == other.runtimeType &&
    email == other.email &&
    name == other.name &&
    phone == other.phone &&
    socio == other.socio &&
    image == other.image &&
    insurance == other.insurance &&
    dateBorn == other.dateBorn &&
    typeBlood == other.typeBlood &&
    auto == other.auto;

  @override
  String toString() {
    return 'UserModel {  email: $email, name: $name, phone: $phone, socio: $socio, image: $image, insurance: $insurance, dateBorn: $dateBorn, typeBlood: $typeBlood, auto: $auto, uid: $uid }';
  }

  UserEntity toEntity() {
    return UserEntity(email, name, phone, socio, image, insurance, dateBorn, typeBlood, auto, uid );
  }

  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
      entity.email,
      entity.name,
      entity.phone,
      entity.socio,
      entity.image,
      entity.insurance,
      entity.dateBorn,
      entity.typeBlood,
      entity.auto,
      entity.uid
    );
  }
}