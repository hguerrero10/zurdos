import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
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

  UserEntity( 
    this.email, 
    this.name, 
    this.phone, 
    this.socio, 
    this.image, 
    this.insurance, 
    this.dateBorn, 
    this.typeBlood, 
    this.auto, 
    this.uid
  );

  Map<String, Object> toJson() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'socio': socio,
      'insurance': insurance,
      'image': image,
      'dateBorn': dateBorn,
      'typeBlood': typeBlood,
      'auto': auto,
      'uid': uid,
    };
  }

  @override
  String toString() {
    return 'UserEntity { email: $email, name: $name, phone: $phone, socio: $socio, image: $image, insurance: $insurance, dateBorn: $dateBorn, typeBlood: $typeBlood, auto: $auto, uid: $uid }';
  }

  static UserEntity fromJson(Map<String, Object> json) {
    return UserEntity(
      json['email'] as String,
      json['name'] as String,
      json['phone'] as String,
      json['socio'] as String,
      json['image'] as String,
      json['insurance'] as String,
      json['dateBorn'] as String,
      json['typeBlood'] as String,
      json['auto'] as String,
      json['uid'] as String
    );
  }

  static UserEntity fromSnapshot(DocumentSnapshot snap) {
    return UserEntity(
      snap.get('email'),
      snap.get('name'),
      snap.get('phone'),
      snap.get('socio'),
      snap.get('image'),
      snap.get('insurance'),
      snap.get('dateBorn'),
      snap.get('typeBlood'),
      snap.get('auto'),
      snap.id
    );
  }

  Map<String, Object> toDocument() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'socio': socio,
      'image': image,
      'insurance' : insurance,
      'dateBorn': dateBorn,
      'typeBlood': typeBlood,
      'auto': auto
    };
  }
}