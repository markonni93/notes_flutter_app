import '../model/user.dart';

abstract class NotesSharedPrefs {
  Future<void> insertUser(NoteUser user);

  Future<NoteUser?> getUser();

  Future<void> removeUser();

  Future<void> insertDefaultUser();
}
