import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ SIGN UP (Create Account)
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // success, no error message
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  // ✅ LOGIN (Sign In)
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  // ✅ LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ✅ Check if user is logged in
  User? get currentUser => _auth.currentUser;
}
