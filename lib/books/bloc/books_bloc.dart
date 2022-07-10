import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_multi_selection/models/Book.dart';
import 'package:equatable/equatable.dart';

part 'books_event.dart';
part 'books_state.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  BooksBloc({
    bool isSelect = false,
  }) : super(const BooksState()) {
    on<BooksFetch>(_onTimesheetsFetchRequested);

    on<BooksActionMode>(_onTimesheetsEditModeToggleRequested);

    on<BooksSelect>(_onTimesheetsSelectRequested);

    on<BooksDeleteSelected>(_onBooksDeleteSelectedRequested);
  }

  FutureOr<void> _onBooksDeleteSelectedRequested(
      BooksDeleteSelected event, Emitter<BooksState> emit) async {
    List<int> selectedBooks = state.selected;
    for (int id in selectedBooks) {
      Book toDelete = state.books.firstWhere((element) => element.id == id);

      emit(state.copyWith(
        status: BooksStatus.success,
        books: [...state.books]..removeWhere((element) => element == toDelete),
        selected: [...state.selected]..remove(id),
      ));
    }
  }

  /// This event adds or removes the [event.select] from the [state.selected]
  /// so that you can deselect an index by tapping the selected
  FutureOr<void> _onTimesheetsSelectRequested(
      BooksSelect event, Emitter<BooksState> emit) async {
    /// [state.selected] contains the [event.selected]
    /// remove it from the selection list
    if (state.selected.contains(event.select)) {
      emit(
        state.copyWith(
          status: BooksStatus.success,
          selected: [...state.selected]..remove(event.select),
        ),
      );
      return;
    }

    /// otherwise add it to the selection list
    emit(
      state.copyWith(
        status: BooksStatus.success,
        selected: [...state.selected, event.select],
      ),
    );
  }

  /// This toggles the action mode of the time sheet screen
  FutureOr<void> _onTimesheetsEditModeToggleRequested(
      BooksActionMode event, Emitter<BooksState> emit) async {
    emit(
      state.copyWith(
        isActionMode: !state.isActionMode,
        selected: [],
      ),
    );
  }

  FutureOr<void> _onTimesheetsFetchRequested(
      BooksFetch event, Emitter<BooksState> emit) async {
    emit(state.copyWith(status: BooksStatus.loading));

    List<Book> books = [
      Book(id: 1, name: 'Lord of Rings', author: 'J.R.R. Tolkien'),
      Book(id: 2, name: 'Harry Potter', author: 'J.K Rowling'),
      Book(id: 3, name: 'Dune', author: 'Frank Herbert'),
    ];

    emit(
      state.copyWith(
        status: BooksStatus.success,
        books: books,
      ),
    );
  }
}
