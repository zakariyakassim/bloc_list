part of 'list_bloc.dart';

@immutable
sealed class ListState {}

class ListInitial extends ListState {}

class ListLoading extends ListState {}

class ListLoaded<T> extends ListState {
  final List<T> items;
  ListLoaded(this.items);
}

class ListEmpty extends ListState {
  final bool empty;
  ListEmpty(this.empty);
}

class ListError extends ListState {
  final String message;
  ListError(this.message);
}
