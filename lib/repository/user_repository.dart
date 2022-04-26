import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:santiago4x4pro/entity/user_entity.dart';
import 'package:santiago4x4pro/models/user_model.dart';

class UserRepository {
  
  final FirebaseAuth _firebaseAuth;
  var usersCollection =  FirebaseFirestore.instance.collection('users');
  bool isSignIn = false;

  UserRepository({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  
  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signUp(String email, String password, String name, String phone, String socio, String image, String insurance, String typeBlood, String dateBorn, String auto, String uid) async{
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    ).then((value) => {
      usersCollection.doc(value.user!.uid).set(UserModel(email, name, phone, socio, image, insurance, dateBorn, typeBlood, auto, value.user!.uid).toEntity().toDocument())
    });
  }

  Future<List<void>> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<UserModel> getUser(String uid) async {
    var user = await usersCollection.doc(uid).get();

    return UserModel.fromEntity(UserEntity.fromSnapshot(user));
  }

   Future<String> getUserId() async {
    return (_firebaseAuth.currentUser)!.uid;
  }

  Stream<List<UserModel>> users() {
    return usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromEntity(UserEntity.fromSnapshot(doc))).toList();
    });
  }

  Future<void> updateUsers(UserModel update) {
    return usersCollection.doc(update.uid).update(update.toEntity().toDocument());
  }
}
 