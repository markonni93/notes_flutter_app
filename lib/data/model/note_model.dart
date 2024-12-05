class NoteModel {
  final int id;
  final String note;
  final String title;
  final String createdAt;

  NoteModel({required this.id, required this.note, required this.title, required this.createdAt});

  Map<String, Object?> toMap() {
    return {'note': note, 'title': title, 'createdAt': createdAt};
  }
}
