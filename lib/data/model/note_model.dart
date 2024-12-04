class NoteModel {
  final int id;
  final String note;
  final String title;

  NoteModel({required this.id, required this.note, required this.title});

  Map<String, Object?> toMap() {
    return {'note': note, 'title': title};
  }
}
