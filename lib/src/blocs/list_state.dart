part of 'list_bloc.dart';

@immutable
sealed class ListState {}

class ListInitial extends ListState {}

class ListLoading extends ListState {}

class ListLoaded<T> extends ListState {
  final List<T> items;
  ListLoaded(this.items);
}

class DataAdded<T> extends ListState {
  final T addedItem;
  DataAdded(this.addedItem);
}

class DataDeleted<T> extends ListState {
  final T item;
  DataDeleted(this.item);
}

class ListError extends ListState {
  final String message;
  ListError(this.message);
}
