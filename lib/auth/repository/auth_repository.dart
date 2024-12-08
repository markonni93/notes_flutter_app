import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_notes/auth/repository/model/user.dart';
import 'package:quick_notes/data/notes_cache_manager.dart';

import 'auth_exception.dart';

class AuthenticationRepository {
  AuthenticationRepository(
      {required NotesCacheManager cache,
      required FirebaseAuth firebaseAuth,
      required GoogleSignIn googleSignIn})
      : _cache = cache,
        _googleSignIn = googleSignIn,
        _firebaseAuth = firebaseAuth;

  final NotesCacheManager _cache;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @visibleForTesting
  bool isWeb = kIsWeb;

  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  Stream<NoteUser?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser != null) {
        final user = NoteUser.fromFirebaseUser(firebaseUser);
        _cache.insertUser(user);
        return user;
      } else {
        return null;
      }
    });
  }

  Future<NoteUser?> get currentUser async {
    return await _cache.getUser();
  }

  Future<void> logInWithGoogle() async {
    try {
      late final AuthCredential credential;
      if (isWeb) {
        final googleProvider = GoogleAuthProvider();
        final userCredential = await _firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  Future<void> continueWithoutSignup() async {
    return await _cache.insertDefaultUser();
  }

  Future<void> logoutCurrentUser() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw Exception("Something went wrong");
    }
  }
}
