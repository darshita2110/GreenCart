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

      // Try to save user profile to Firestore (non-blocking)
      // If Firestore fails, the user is still created in Firebase Auth
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toFirebase());
      } catch (_) {
        // Firestore write failed — user is still authenticated, continue
      }

      return newUser;
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Sign up failed');
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

      // Try to fetch user profile from Firestore
      try {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          return User.fromFirebase(userDoc.data()!, user.uid);
        }
      } catch (_) {
        // Firestore read failed — fall back to Firebase Auth data
      }

      // Fallback: build User from Firebase Auth data
      return User(
        id: user.uid,
        email: user.email ?? email,
        displayName: user.displayName ?? '',
        createdAt: DateTime.now(),
      );
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
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

    // Try Firestore first, fallback to Firebase Auth data
    try {
      final userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        return User.fromFirebase(userDoc.data()!, user.uid);
      }
    } catch (_) {
      // Firestore unavailable — use Firebase Auth data
    }

    return User(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      createdAt: DateTime.now(),
    );
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((fbUser) async {
      if (fbUser == null) return null;

      // Try Firestore first, fallback to Firebase Auth data
      try {
        final userDoc =
            await _firestore.collection('users').doc(fbUser.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          return User.fromFirebase(userDoc.data()!, fbUser.uid);
        }
      } catch (_) {
        // Firestore unavailable
      }

      return User(
        id: fbUser.uid,
        email: fbUser.email ?? '',
        displayName: fbUser.displayName ?? '',
        createdAt: DateTime.now(),
      );
    });
  }
}