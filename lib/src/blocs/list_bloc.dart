import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
part 'list_event.dart';
part 'list_state.dart';

//typedef DataProvider<T> = Future<List<T>> Function();
typedef DataAdder<T> = Future<void> Function(T item);
typedef DataDeleter = Future<void> Function(String id);
typedef DataUpdater<T> = Future<void> Function(T item);

class ListBloc<T> extends Bloc<DataEvent, ListState> {
  final Future<List<T>> Function() dataProvider;
  // final DataAdder<T> dataAdder;
  // final DataDeleter dataDeleter;
  // final DataUpdater<T> dataUpdater;

  ListBloc({
    required this.dataProvider,
    // required this.dataAdder,
    // required this.dataDeleter,
    // required this.dataUpdater,
  }) : super(ListInitial()) {
    on<LoadDataEvent>(_onLoadData);
    // on<AddDataEvent<T>>(_onAddData);
    // on<DeleteDataEvent>(_onDeleteData);
    // on<UpdateDataEvent<T>>(_onUpdateData);
  }

  Future<void> _onLoadData(LoadDataEvent event, Emitter<ListState> emit) async {
    emit(ListLoading());

    await Future.delayed(const Duration(milliseconds: 2000));

    try {
      final items = await dataProvider();
      if (items.isEmpty) {
        emit(ListEmpty(true));
      } else {
        emit(ListLoaded<T>(items));
      }
    } catch (e) {
      emit(ListError(e.toString()));
    }
  }

  // Implement _onAddData, _onDeleteData, _onUpdateData similarly
}
