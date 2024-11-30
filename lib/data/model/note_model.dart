class NoteModel {
  final int id;
  final String note;

  NoteModel({required this.id, required this.note});

  Map<String, Object?> toMap() {
    return {'id': id, 'description': note};
  }
}
