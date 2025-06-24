import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔐 Register User
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Registration error: ${e.message}");
      return null;
    }
  }

  // 🔓 Login User
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("⚠️ Login error: ${e.message}");
      return null;
    }
  }

  // 🚪 Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 👤 Get Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // 🔄 Auth State Stream (optional)
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
