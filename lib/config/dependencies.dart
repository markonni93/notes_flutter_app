import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:quick_notes/data/notes_cache_manager.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_impl.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (context) => NotesCacheManagerImpl() as NotesCacheManager,
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
