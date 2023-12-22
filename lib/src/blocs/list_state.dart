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
  final T item;
  DataAdded(this.item);
}

class DataDeleted<T> extends ListState {
  final T item;
  DataDeleted(this.item);
}

class DataUpdated<T> extends ListState {
  final T newItem;
  final T oldItem;
  DataUpdated({required this.newItem, required this.oldItem});
}

class ListError extends ListState {
  final String message;
  ListError(this.message);
}
