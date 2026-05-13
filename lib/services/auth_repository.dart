import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._firebaseAuth, this._firestore);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithGoogle() async {
    // TODO: Implement Google sign-in
  }

  Future<void> signInWithApple() async {
    // TODO: Implement Apple sign-in
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> updateUserFirestore({required String uid, required Map<String, dynamic> data}) async {
    await _firestore.collection('members').doc(uid).set(data, SetOptions(merge: true));
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
