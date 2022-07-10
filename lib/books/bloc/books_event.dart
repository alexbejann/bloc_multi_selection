part of 'books_bloc.dart';

abstract class BooksEvent extends Equatable {
  const BooksEvent();
}

class BooksFetch extends BooksEvent {
  const BooksFetch();

  @override
  List<Object?> get props => [];
}

class BooksActionMode extends BooksEvent {
  const BooksActionMode();

  @override
  List<Object?> get props => [];
}

class BooksSelect extends BooksEvent {
  const BooksSelect(this.select);

  final int select;

  @override
  List<Object?> get props => [select];
}

class BooksDeleteSelected extends BooksEvent {
  const BooksDeleteSelected();

  @override
  List<Object?> get props => [];
}
