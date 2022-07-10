import 'package:equatable/equatable.dart';

class Book extends Equatable {
  Book({
    required this.id,
    required this.name,
    required this.author,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'] as int,
        name: json['name'] as String,
        author: json['author'] as String,
      );

  int id;
  String name;
  String author;

  @override
  List<Object?> get props => [id, name, author];
}
