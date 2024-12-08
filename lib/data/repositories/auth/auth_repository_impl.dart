import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_notes/data/repositories/auth/auth_repository.dart';

import '../../../util/result.dart';
import '../../notes_cache_manager.dart';
import 'auth_exception.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl(
      {required NotesCacheManager cache,
      required FirebaseAuth firebaseAuth,
      required GoogleSignIn googleSignIn})
      : _cache = cache,
        _googleSignIn = googleSignIn,
        _firebaseAuth = firebaseAuth;

  @visibleForTesting
  bool isWeb = kIsWeb;

  final NotesCacheManager _cache;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<bool> get isAuthenticated async {
    // _firebaseAuth.authStateChanges().map((firebaseUser) {
    //   if (firebaseUser != null) {
    //     final user = NoteUser.fromFirebaseUser(firebaseUser);
    //     _cache.insertUser(user);
    //     return true;
    //   } else {
    //     return false;
    //   }
    // });
    return false;
  }

  @override
  Future<Result<void>> login() async {
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
      final result = await _firebaseAuth.signInWithCredential(credential);
      if (result.user != null) {
        return const Result.ok(null);
      } else {
        return Result.error(Exception("Unknown error ocurred"));
      }
    } on FirebaseAuthException catch (e) {
      return Result.error(LogInWithGoogleFailure.fromCode(e.code));
    } catch (_) {
      return const Result.error(LogInWithGoogleFailure());
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _cache.removeUser()
      ]);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception("Something went wrong"));
    } finally {
      notifyListeners();
    }
  }
}
