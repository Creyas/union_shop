import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ CREATE ACCOUNT + SAVE TO FIRESTORE
  Future<User?> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // 1️⃣ Create account in Firebase Authentication
      UserCredential userCred =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCred.user!.uid;

      // 2️⃣ Store user info in Firestore Database
      await _db.collection("users").doc(userId).set({
        "name": name,
        "email": email,
        "createdAt": Timestamp.now(),
      });

      return userCred.user;
    } catch (e) {
      print("❌ Account creation failed: $e");
      return null;
    }
  }

  // ✅ LOGIN
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCred =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCred.user;
    } catch (e) {
      print("❌ Login failed: $e");
      return null;
    }
  }

  // ✅ LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ✅ GET CURRENT USER
  User? get currentUser => _auth.currentUser;
}
