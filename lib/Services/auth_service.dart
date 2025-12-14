import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // -----------------------------
  // SIGNUP
  // -----------------------------
  Future<User?> signUp(String email, String password, String fullName) 
 async {
    try {
      // Firebase Auth create user
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Save user info in Firestore
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": email,
          "fullName": fullName,
          "createdAt": DateTime.now(),
        });
      }

      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // -----------------------------
  // LOGIN
  // -----------------------------
  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // -----------------------------
  // LOGOUT
  // -----------------------------
  Future<void> logout() async {
    await _auth.signOut();
  }

  // -----------------------------
  // GET CURRENT USER
  // -----------------------------
  User? get currentUser => _auth.currentUser;

  // -----------------------------
  // GET USER DATA FROM FIRESTORE
  // -----------------------------
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection("users").doc(uid).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error fetching user data: $e");
    }
  }
}
