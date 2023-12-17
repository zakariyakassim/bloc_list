part of 'list_bloc.dart';

@immutable
sealed class DataEvent {}

class LoadDataEvent extends DataEvent {}

class AddDataEvent<T> extends DataEvent {
  final T item;
  AddDataEvent(this.item);
}

class DeleteDataEvent extends DataEvent {
  final String id;
  DeleteDataEvent(this.id);
}

class UpdateDataEvent<T> extends DataEvent {
  final T item;
  UpdateDataEvent(this.item);
}
