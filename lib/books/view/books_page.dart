import 'package:bloc_multi_selection/books/bloc/books_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BooksBloc()..add(const BooksFetch()),
      child: _BooksView(),
    );
  }
}

class _BooksView extends StatelessWidget {
  const _BooksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _CustomAppBar(),
        body: RefreshIndicator(
          onRefresh: () async => null,
          child: BlocConsumer<BooksBloc, BooksState>(
            listener: (context, state) {
              if (state.status == BooksStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Something went wrong!'),
                    ),
                  );
              }
            },
            builder: (context, state) {
              if (state.status == BooksStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state.books.isEmpty) {
                if (state.status != BooksStatus.success) {
                  return const SizedBox();
                } else {
                  return const Center(
                    child: Text('No books available'),
                  );
                }
              }
              return ListView.separated(
                separatorBuilder: (_, index) => const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: state.books.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  /// onLongPress should activate the DeleteActionMode
                  /// and Replace the current AppBar with Delete action mode
                  /// and select the item
                  return ListTile(
                    onLongPress: () {
                      if (!state.isActionMode) {
                        context.read<BooksBloc>().add(
                              const BooksActionMode(),
                            );
                      }
                      context.read<BooksBloc>().add(
                            BooksSelect(
                              state.books[index].id,
                            ),
                          );
                    },
                    onTap: () {
                      if (state.selected.length == 1 &&
                          state.isActionMode &&
                          state.selected.contains(state.books[index].id)) {
                        context.read<BooksBloc>()
                          ..add(
                            BooksSelect(
                              state.books[index].id,
                            ),
                          )
                          ..add(const BooksActionMode());
                        return;
                      }
                      if (state.isSelect) {
                        Navigator.pop(
                          context,
                          state.books[index],
                        );
                        return;
                      }
                      if (state.isActionMode) {
                        context.read<BooksBloc>().add(
                              BooksSelect(
                                state.books[index].id,
                              ),
                            );
                        return;
                      }
                      // Navigator.of(context)
                      //     .pushNamed(
                      //       TimeSheetLinesScreen.routeName,
                      //       arguments: state.timesheets[index].getId(),
                      //     )
                      //     .then((value) async => context
                      //         .read<BooksBloc>()
                      //         .add(const BooksFetch()));
                    },
                    selected: state.selected.contains(state.books[index].id),
                    key: Key(state.books[index].id.toString()),
                    title: Text(state.books[index].name),
                    subtitle: Text(state.books[index].author),
                  );
                },
              );
            },
          ),
        ),
      );
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksState>(
      builder: (context, state) {
        if (state.isActionMode) {
          return AppBar(
            leading: BackButton(
              onPressed: () =>
                  context.read<BooksBloc>().add(const BooksActionMode()),
            ),
            title: Text(state.selected.length.toString()),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.delete,
                ),
                onPressed: () =>
                    context.read<BooksBloc>().add(const BooksDeleteSelected()),
              )
            ],
          );
        }
        return AppBar(
          title: const Text('BLoC multi selection demo'),
          actions: state.isSelect
              ? null
              : [
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                    ),
                    onPressed: () =>
                        context.read<BooksBloc>().add(const BooksActionMode()),
                  )
                ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
