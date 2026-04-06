import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Current User ──────────────────────────────────────────────
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── Sign In ───────────────────────────────────────────────────
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Check if user document exists in Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // Sign out if no user profile found
        await _auth.signOut();
        return AuthResult(
          success: false,
          error: 'User profile not found. Contact admin.',
        );
      }

      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: _handleAuthError(e.code));
    } catch (e) {
      return AuthResult(success: false, error: 'An unexpected error occurred.');
    }
  }

  // ─── Sign Out ──────────────────────────────────────────────────
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ─── Password Reset ────────────────────────────────────────────
  Future<AuthResult> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return AuthResult(success: true);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, error: _handleAuthError(e.code));
    } catch (e) {
      return AuthResult(success: false, error: 'An unexpected error occurred.');
    }
  }

  // ─── Error Handler ─────────────────────────────────────────────
  String _handleAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'user-disabled':
        return 'This account has been disabled. Contact admin.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      default:
        return 'Login failed. Please try again.';
    }
  }
}

// ─── Auth Result Model ─────────────────────────────────────────────
// Clean wrapper to return success/error from auth operations
class AuthResult {
  final bool success;
  final String? error;

  AuthResult({required this.success, this.error});
}
