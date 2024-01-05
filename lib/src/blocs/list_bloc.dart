import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'list_event.dart';
part 'list_state.dart';

class BlocResponse<T> {
  final bool success;
  final T? data;

  BlocResponse({required this.success, this.data});
}

typedef DataProvider<T> = Future<List<T>> Function([dynamic data]);
typedef DataAdder<T> = Future<BlocResponse<T>> Function(T item);
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
      var items = await dataProvider(event.data);
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
    final currentState = state;
    if (currentState is ListLoaded<T>) {
      List<T> newList = [event.item, ...currentState.items ?? []];
      emit(ListLoaded<T>(newList));
      emit(DataAdding<T>(event.item));

      if (dataAdder != null) {
        var response = await dataAdder!(event.item);
        if (response.success && response.data != null) {
          int index = newList.indexOf(event.item);

          if (index != -1) {
            newList[index] = response.data as T;
          }
          emit(DataAdded<T>(response.data));
          emit(ListLoaded<T>(null));
        }
      }
    }
  }

  FutureOr<void> _onDeleteData(
      DeleteDataEvent event, Emitter<ListState> emit) async {
    final currentState = state;
    if (currentState is ListLoaded<T>) {
      emit(DataDeleting<T>(event.item));

      if (dataDeleter != null) {
        bool deleted = await dataDeleter!(event.item);

        if (deleted) {
          final updatedItems = List<T>.from(currentState.items ?? []);
          updatedItems.remove(event.item);
          emit(DataDeleted<T>(event.item));
          emit(ListLoaded<T>(updatedItems));
        }
      }
    }
  }

  //   FutureOr<void> _onDeleteData(
  //     DeleteDataEvent event, Emitter<ListState> emit) async {
  //   if (dataDeleter != null) {

  //     emit(DataDeleting<T>(event.item));
  //     bool deleted = await dataDeleter!(event.item);

  //     if (deleted) {
  //       final currentState = state;
  //       if (currentState is ListLoaded<T>) {
  //         final updatedItems = List<T>.from(currentState.items ?? []);
  //         updatedItems.remove(event.item);
  //         emit(DataDeleted<T>(event.item));
  //         emit(ListLoaded<T>(updatedItems));
  //       }
  //     }
  //   }
  // }

  FutureOr<void> _onUpdateData(
      UpdateDataEvent<T> event, Emitter<ListState> emit) async {
    final currentState = state;
    if (currentState is ListLoaded<T>) {
      final updatedItems = List<T>.from(currentState.items ?? []);

      int itemIndex =
          updatedItems.indexWhere((element) => element == event.oldItem);
      emit(DataUpdating<T>(oldItem: event.oldItem, newItem: event.newItem));

      if (dataUpdater != null) {
        bool updated = await dataUpdater!(event.newItem);
        if (updated) {
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
