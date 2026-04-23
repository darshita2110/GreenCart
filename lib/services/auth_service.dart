import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_cart/models/user.dart';

class AuthService {
  final _auth = fb.FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<User> signup({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user!;
      await user.updateDisplayName(displayName);

      final newUser = User(
        id: user.uid,
        email: email,
        displayName: displayName,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(newUser.toFirebase());
      return newUser;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user!;
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      return User.fromFirebase(userDoc.data() ?? {}, user.uid);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> forgotPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<User?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc.exists ? User.fromFirebase(userDoc.data() ?? {}, user.uid) : null;
    } catch (e) {
      return null;
    }
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((fbUser) async {
      if (fbUser == null) return null;
      try {
        final userDoc = await _firestore.collection('users').doc(fbUser.uid).get();
        return userDoc.exists ? User.fromFirebase(userDoc.data() ?? {}, fbUser.uid) : null;
      } catch (e) {
        return null;
      }
    });
  }
}