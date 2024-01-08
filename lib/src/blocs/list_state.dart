part of 'list_bloc.dart';

@immutable
sealed class ListState {}

class ListInitial extends ListState {}

class ListLoading extends ListState {}

class ListLoaded<T> extends ListState {
  final List<T>? items;
  final bool updateList;
  ListLoaded(this.items, {this.updateList = false});
}

class ItemError<T> extends ListState {
  final ErrorType errorType;
  final T item;
  final String message;
  ItemError(this.errorType, this.item, this.message);
}

class DataAdded<T> extends ListState {
  final T? item;
  DataAdded(this.item);
}

class DataDeleting<T> extends ListState {
  final T? item;
  DataDeleting(this.item);
}

class DataUpdating<T> extends ListState {
  final T newItem;
  final T oldItem;
  DataUpdating({required this.newItem, required this.oldItem});
}

class DataAdding<T> extends ListState {
  final T? item;
  DataAdding(this.item);
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
