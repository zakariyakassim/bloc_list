import 'package:bloc_list/bloc_list.dart';
import 'package:example/data/data_service.dart';
import 'package:example/models/todo_model.dart';

class TodoBloc extends ListBloc<TodoModel> {
  final DataService dataService;
  TodoBloc(this.dataService)
      : super(
          dataProvider: () => dataService.getTodoList(),
          dataAdder: (item) => dataService.add(item),
          dataDeleter: (item) => dataService.delete(item),
          dataSorter: (items, [compare]) =>
              items.sort((a, b) => b.created.compareTo(a.created)),
          dataUpdater: (item) => dataService.update(item),
        );
}
