import 'package:equatable/equatable.dart';

final class NoteListUiModel extends Equatable {
  final String id;
  final String text;
  final bool isChecked;

  const NoteListUiModel(
      {required this.id, required this.text, required this.isChecked});

  NoteListUiModel copyWith({
    String? id,
    String? text,
    bool? isChecked,
  }) {
    return NoteListUiModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  @override
  List<Object?> get props => [id, text, isChecked];
}
