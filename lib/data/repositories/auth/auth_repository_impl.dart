import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_notes/data/repositories/auth/auth_repository.dart';

import '../../../util/result.dart';
import '../../shared_prefs/notes_shared_prefs.dart';
import 'auth_exception.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl(
      {required NotesSharedPrefs cache,
      required FirebaseAuth firebaseAuth,
      required GoogleSignIn googleSignIn})
      : _cache = cache,
        _googleSignIn = googleSignIn,
        _firebaseAuth = firebaseAuth;

  @visibleForTesting
  bool isWeb = kIsWeb;

  final NotesSharedPrefs _cache;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<bool> get isAuthenticated async {
    return await _firebaseAuth.authStateChanges().map((User? user) {
      return user != null;
    }).first;
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
  Future<Result<void>> skipLogin() async {
    await _cache.insertDefaultUser();
    print("skipping login");
    return const Result.ok(null);
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
