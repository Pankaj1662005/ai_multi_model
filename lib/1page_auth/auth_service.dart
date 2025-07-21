import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Enhanced signup that handles existing users properly
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create new user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null)
        return 'Failed to create user, try re-installing the app';

      // Store the Name temporarily in a pending collection for later use
      await _storePendingUserData(user.uid, name, email);

      await user.sendEmailVerification();
      return 'A verification email has been sent to $email. Please verify to complete signup.';
    } on FirebaseAuthException catch (e) {
      print('----------error-----$e');
      if (e.code == 'email-already-in-use') {
        return await _handleExistingAuthUser(email);
      }
      return e.message ?? 'An unknown error occurred.';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  // Store pending user data for users who haven't verified yet
  Future<void> _storePendingUserData(
      String uid, String name, String email) async {
    await _firestore.collection('pending_users').doc(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Handle existing auth user case
  Future<String> _handleExistingAuthUser(String email) async {
    try {
      // Check if user is in our main users collection
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return 'Account already exists and is verfied. Please login instead.';
      } else {
        return 'Account exists but not verified. Please check your email for verification link, then try logging in.';
      }
    } catch (e) {
      return 'Account with this email already exists. Please try logging in or use password reset if needed.';
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null)
        return 'Failed to login user, try re-installing the app';

      await user.reload();
      final refreshedUser = _auth.currentUser;

      if (refreshedUser == null || !refreshedUser.emailVerified) {
        print('---------------3i844-----------------444--');
        await _auth.signOut();
        return 'Account not verified or not fully signed up. Check your inbox for the verification link.';
      }

      // Check if user exists in main users collection
      final docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (!docSnapshot.exists) {
        // User is verified but not in main collection - complete their signup and pnakaj move the user from pending to user this will happen only once
        final pendingDoc =
            await _firestore.collection('pending_users').doc(user.uid).get();

        if (pendingDoc.exists) {
          // Move from pending to main users collection
          final pendingData = pendingDoc.data()!;
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'name': pendingData['name'],
            'createdAt': FieldValue.serverTimestamp(),
          });

          // Remove from pending
          await pendingDoc.reference.delete();

          return 'Success';
        } else {
          await _auth.signOut();
          print(
              'pankaj this account was first signup then verifed and then deleted , it means verified but not in user nor in pending account , it means chnaged from data base so contact you');
          return 'Account setup incomplete. Please contact support.';
        }
      }

      return 'Success';
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'invalid-credential') {
        return 'Invalid email or password or create a account';
      } else if (e.code == 'user-disabled') {
        return 'This account has been disabled.';
      }
      return e.message ?? 'Login failed. Please try again.';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  // Complete signup for already verified users (alternative method)
  Future<String> completeSignUpIfEmailVerified({
    required String name,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return 'No user is signed in.';

    await user.reload();
    if (!user.emailVerified)
      return 'Please verify your email before continuing.';

    final userDoc = _firestore.collection('users').doc(user.uid);

    final exists = await userDoc.get();
    if (exists.exists) return 'Account already created.';

    await userDoc.set({
      'uid': user.uid,
      'email': user.email,
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Remove from pending if exists
    await _firestore.collection('pending_users').doc(user.uid).delete();

    return 'Success';
  }

  // resend email for verification
  Future<String> resendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null) return 'No user is logged in.';

    if (user.emailVerified) {
      return 'Email is already verified. You can now login.';
    }

    try {
      await user.sendEmailVerification();
      return 'Verification email resent to ${user.email}';
    } catch (e) {
      return 'Failed to resend email. Please try again later.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user info
  Future<Map<String, dynamic>?> getCurrentUserInfo() async {
    final user = _auth.currentUser;
    if (user == null || !user.emailVerified) return null;

    try {
      final docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
