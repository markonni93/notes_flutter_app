import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteUser extends Equatable {
  final String id;
  final String? email;
  final String? name;
  final String? photo;

  // Constructor
  const NoteUser({
    required this.id,
    this.email,
    this.name,
    this.photo,
  });

  // Static empty user to avoid dealing with null
  static const empty = NoteUser(id: 'empty');

  // Check if the user is empty
  bool get isEmpty => this == NoteUser.empty;

  bool get isNotEmpty => this != NoteUser.empty;

  @override
  List<Object?> get props => [id, email, name, photo];

  // Copy with method to create a new instance with modified fields
  NoteUser copyWith({
    String? id,
    String? email,
    String? name,
    String? photo,
  }) {
    return NoteUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photo: photo ?? this.photo,
    );
  }

  NoteUser.fromFirebaseUser(User user)
      : id = user.uid,
        email = user.email,
        name = user.displayName,
        photo = user.photoURL;

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'photo': photo};
  }

  // Convert JSON back to a User object
  factory NoteUser.fromJson(Map<String, dynamic> json) {
    return NoteUser(
      id: json['id'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
    );
  }
}
