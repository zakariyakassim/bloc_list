import 'package:example/models/todo_model.dart';

class DataService {
  final List<TodoModel> _todoList = [];

  Future<List<TodoModel>> getTodoList() async {
    await Future.delayed(const Duration(seconds: 3));
    return _todoList;
  }

  Future<bool> add(TodoModel todo) {
    // return true if the item was added successfully
    return Future.value(true);
  }

  Future<bool> delete(TodoModel todo) {
    // return true if the item was deleted successfully
    return Future.value(true);
  }

  Future<bool> update(TodoModel todo) {
    // return true if the item was updated successfully
    return Future.value(true);
  }
}
