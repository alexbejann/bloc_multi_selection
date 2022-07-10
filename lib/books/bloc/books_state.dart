part of 'books_bloc.dart';

enum BooksStatus { initial, loading, success, failure }

class BooksState extends Equatable {
  const BooksState({
    this.status = BooksStatus.initial,
    this.isActionMode = false,
    this.books = const [],
    this.selected = const [],
    this.isSelect = false,
  });

  final BooksStatus status;
  final bool isActionMode;
  final List<Book> books;
  final List<int> selected;
  final bool isSelect;

  BooksState copyWith({
    BooksStatus? status,
    List<Book>? books,
    List<int>? selected,
    bool? isSelect,
    bool? isActionMode,
  }) {
    return BooksState(
      status: status ?? this.status,
      isActionMode: isActionMode ?? this.isActionMode,
      books: books ?? this.books,
      selected: selected ?? this.selected,
      isSelect: isSelect ?? this.isSelect,
    );
  }

  @override
  List<Object?> get props => [status, isActionMode, books, isSelect, selected];
}
