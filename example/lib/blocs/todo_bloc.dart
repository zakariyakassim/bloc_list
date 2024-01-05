import 'package:bloc_list/bloc_list.dart';
import 'package:example/data/data_service.dart';
import 'package:example/models/todo_model.dart';

class TodoBloc extends ListBloc<TodoModel> {
  final DataService dataService;
  TodoBloc(this.dataService)
      : super(
          dataProvider: ([id]) => dataService.getTodoList(id),
          dataAdder: (item) => dataService.addTodo(item),
          dataDeleter: (item) => dataService.deleteTodo(item),
          dataSorter: (items, [compare]) =>
              items.sort((a, b) => b.created.compareTo(a.created)),
          dataUpdater: (item) => dataService.updateTodo(item),
        );
}
