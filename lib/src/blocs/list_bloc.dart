import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'list_event.dart';
part 'list_state.dart';

enum ErrorType { itemAdding, itemDeleting, itemUpdating }

class BlocResponse<T> {
  final bool success;
  final T? data;
  final String message;
  BlocResponse(
      {required this.success, this.data, this.message = "An error occured"});
}

typedef DataProvider<T> = Future<BlocResponse<dynamic>> Function(
    [dynamic data]);
typedef DataAdder<T> = Future<BlocResponse<T>> Function(T item);
typedef DataDeleter<T> = Future<BlocResponse<T>> Function(T item);
typedef DataSorter<T> = Function(List<T> items,
    [int Function(T a, T b)? compare]);
typedef DataUpdater<T> = Future<BlocResponse<T>> Function(T item);

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
      var response = await dataProvider(event.data);
      if (response.success) {
        final list = List<T>.from(response.data as List<T>? ?? []);
        if (list.isNotEmpty && dataSorter != null) {
          dataSorter!(list);
        }
        emit(ListLoaded<T>(list, updateList: true));
      } else {
        emit(ListError(response.message));
      }
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
        try {
          var response = await dataAdder!(event.item);
          if (response.success && response.data != null) {
            int index = newList.indexOf(event.item);

            if (index != -1) {
              newList[index] = response.data as T;
            }
            emit(DataAdded<T>(response.data));
            emit(ListLoaded<T>(newList, updateList: false));
          } else {
            emit(ItemError<T>(
                ErrorType.itemAdding, event.item, response.message));
            emit(ListLoaded<T>(currentState.items ?? []));
          }
        } catch (e) {
          emit(ItemError<T>(ErrorType.itemAdding, event.item, e.toString()));
          emit(ListLoaded<T>(currentState.items ?? []));
        }
      }
    }
  }

  // FutureOr<void> _onAddData(
  //     AddDataEvent<T> event, Emitter<ListState> emit) async {
  //   final currentState = state;
  //   if (currentState is ListLoaded<T>) {
  //     List<T> newList = [event.item, ...currentState.items ?? []];
  //     emit(ListLoaded<T>(newList));
  //     emit(DataAdding<T>(event.item));

  //     if (dataAdder != null) {
  //       var response = await dataAdder!(event.item);
  //       if (response.success && response.data != null) {
  //         int index = newList.indexOf(event.item);

  //         if (index != -1) {
  //           newList[index] = response.data as T;
  //         }
  //         emit(DataAdded<T>(response.data));
  //         emit(ListLoaded<T>(newList, updateList: false));
  //       }
  //     }
  //   }
  // }

  FutureOr<void> _onDeleteData(
      DeleteDataEvent event, Emitter<ListState> emit) async {
    final currentState = state;
    if (currentState is ListLoaded<T>) {
      emit(DataDeleting<T>(event.item));
      if (dataDeleter != null) {
        try {
          var response = await dataDeleter!(event.item);
          if (response.success) {
            final updatedItems = List<T>.from(currentState.items ?? []);
            updatedItems.remove(event.item);
            emit(DataDeleted<T>(event.item));
            emit(ListLoaded<T>(updatedItems, updateList: true));
          } else {
            emit(ItemError<T>(
                ErrorType.itemDeleting, event.item, response.message));
            emit(ListLoaded<T>(currentState.items ?? []));
          }
        } catch (e) {
          emit(ItemError<T>(ErrorType.itemDeleting, event.item, e.toString()));
          emit(ListLoaded<T>(currentState.items ?? []));
        }
      }
    }
  }

  FutureOr<void> _onUpdateData(
      UpdateDataEvent<T> event, Emitter<ListState> emit) async {
    final currentState = state;
    if (currentState is ListLoaded<T>) {
      final updatedItems = List<T>.from(currentState.items ?? []);

      int itemIndex =
          updatedItems.indexWhere((element) => element == event.oldItem);
      emit(DataUpdating<T>(oldItem: event.oldItem, newItem: event.newItem));
      if (itemIndex == -1) {
        emit(ItemError<T>(
            ErrorType.itemUpdating, event.oldItem, "Item not found"));
        emit(ListLoaded<T>(currentState.items ?? []));
        return;
      }
      if (dataUpdater != null) {
        try {
          var response = await dataUpdater!(event.newItem);
          if (response.success && response.data != null) {
            updatedItems[itemIndex] = event.newItem;
            emit(
                DataUpdated<T>(oldItem: event.oldItem, newItem: event.newItem));
            emit(ListLoaded<T>(updatedItems, updateList: true));
          } else {
            emit(ItemError<T>(
                ErrorType.itemUpdating, event.oldItem, response.message));
            emit(ListLoaded<T>(currentState.items ?? []));
          }
        } catch (e) {
          emit(ItemError<T>(
              ErrorType.itemUpdating, event.oldItem, e.toString()));
          emit(ListLoaded<T>(currentState.items ?? []));
        }
      }
    }
  }
}
