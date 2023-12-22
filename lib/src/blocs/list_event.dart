part of 'list_bloc.dart';

@immutable
sealed class DataEvent {}

class LoadDataEvent extends DataEvent {}

class AddDataEvent<T> extends DataEvent {
  final T item;
  AddDataEvent(this.item);
}

class DeleteDataEvent<T> extends DataEvent {
  final T item;
  DeleteDataEvent(this.item);
}

class UpdateDataEvent<T> extends DataEvent {
  final T newItem;
  final T oldItem;
  UpdateDataEvent({required this.newItem, required this.oldItem});
}
