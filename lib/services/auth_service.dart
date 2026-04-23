import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ⚠️ Web ke liye hi clientId use hota hai (Android me zarurat nahi hoti)
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  // 📝 Register User
  static Future<String?> registerUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 🔑 Login User
  static Future<String?> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 🔐 Google Sign-In
  static Future<User?> signInWithGoogle() async {
    try {
      // Google account select
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // user cancelled
      }

      // authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase login
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Google Sign-In Error: ${e.message}");
      return null;
    } catch (e) {
      print("Google Exception: $e");
      return null;
    }
  }

  // 🚪 Logout
  static Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // 👤 Get Current User
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // ✅ Check if logged in
  static bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }
}