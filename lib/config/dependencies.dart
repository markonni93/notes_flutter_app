import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:quick_notes/data/shared_prefs/notes_shared_prefs.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_impl.dart';
import '../data/shared_prefs/notes_shared_prefs_impl.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (context) => NotesSharedPrefsImpl() as NotesSharedPrefs,
    ),
    ChangeNotifierProvider(
      create: (context) => AuthRepositoryImpl(
              cache: context.read(),
              firebaseAuth: FirebaseAuth.instance,
              googleSignIn: GoogleSignIn(scopes: ['profile', 'email']))
          as AuthRepository,
    ),
  ];
}
