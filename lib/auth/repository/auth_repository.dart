import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_notes/auth/repository/model/user.dart';
import 'package:flutter_notes/data/notes_cache_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_exception.dart';

class AuthenticationRepository {
  AuthenticationRepository(
      { required NotesCacheManager cache,
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

  Stream<NoteUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      print("Status changed");
      final user = firebaseUser == null
          ? NoteUser.empty
          : NoteUser.fromFirebaseUser(firebaseUser);
      print("User is $user");
      _cache.insertUser(user);
      return user;
    });
  }

  Future<NoteUser> get currentUser async {
    return await _cache.getUser() ?? NoteUser.empty;
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
}
