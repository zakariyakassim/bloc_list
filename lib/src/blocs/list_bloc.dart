import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'list_event.dart';
part 'list_state.dart';

typedef DataProvider<T> = Future<List<T>> Function();
typedef DataAdder<T> = Future<bool> Function(T item);
typedef DataDeleter<T> = Future<bool> Function(T item);
typedef DataSorter<T> = Function(List<T> items,
    [int Function(T a, T b)? compare]);
typedef DataUpdater<T> = Future<bool> Function(T item);

class ListBloc<T> extends Bloc<DataEvent, ListState> {
  final DataProvider<T> dataProvider;
  final DataAdder<T>? dataAdder;
  final DataDeleter<T>? dataDeleter;
  final DataSorter<T>? dataSorter;
  final DataUpdater<T>? dataUpdater;

  ListBloc({
    required this.dataProvider,
    this.dataAdder,
    this.dataSorter,
    this.dataUpdater,
    this.dataDeleter,
  }) : super(ListInitial()) {
    on<LoadDataEvent>(_onLoadData);
    on<AddDataEvent<T>>(_onAddData);
    on<DeleteDataEvent>(_onDeleteData);
    on<UpdateDataEvent<T>>(_onUpdateData);
  }

  Future<void> _onLoadData(LoadDataEvent event, Emitter<ListState> emit) async {
    emit(ListLoading());
    try {
      var items = await dataProvider();
      if (items.isNotEmpty && dataSorter != null) {
        dataSorter!(items);
      }
      emit(ListLoaded<T>(items));
    } catch (e) {
      emit(ListError(e.toString()));
    }
  }

  FutureOr<void> _onAddData(
      AddDataEvent<T> event, Emitter<ListState> emit) async {
    if (dataAdder != null) {
      bool added = await dataAdder!(event.item);
      if (added) {
        final currentState = state;
        if (currentState is ListLoaded<T>) {
          emit(DataAdded<T>(event.item));
          emit(ListLoaded<T>([event.item, ...currentState.items]));
        }
      }
    }
  }

  FutureOr<void> _onDeleteData(
      DeleteDataEvent event, Emitter<ListState> emit) async {
    if (dataDeleter != null) {
      bool deleted = await dataDeleter!(event.item);
      if (deleted) {
        final currentState = state;
        if (currentState is ListLoaded<T>) {
          final updatedItems = List<T>.from(currentState.items);
          updatedItems.remove(event.item);
          emit(DataDeleted<T>(event.item));
          emit(ListLoaded<T>(updatedItems));
        }
      }
    }
  }

  FutureOr<void> _onUpdateData(
      UpdateDataEvent<T> event, Emitter<ListState> emit) async {
    if (dataUpdater != null) {
      bool updated = await dataUpdater!(event.newItem);
      if (updated) {
        final currentState = state;
        if (currentState is ListLoaded<T>) {
          final updatedItems = List<T>.from(currentState.items);

          int itemIndex =
              updatedItems.indexWhere((element) => element == event.oldItem);

          if (itemIndex != -1) {
            updatedItems[itemIndex] = event.newItem;
            emit(
                DataUpdated<T>(oldItem: event.oldItem, newItem: event.newItem));
            emit(ListLoaded<T>(updatedItems));
          }
        }
      }
    }
  }
}
