import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        profileImage: null,
      );

      await firestore.collection('users').doc(user.id).set(user.toJson());

      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc = await firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      } else {
        throw Exception('User data not found');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      final doc =
          await firestore.collection('users').doc(currentUser.uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
    }
    return null;
  }
}
