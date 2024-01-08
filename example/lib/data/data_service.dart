import 'package:bloc_list/bloc_list.dart';
import 'package:example/models/chat_model.dart';
import 'package:example/models/todo_model.dart';

class DataService {
  final List<TodoModel> _todoList = [];

  final List<ChatModel> _chatList = [
    ChatModel(
        id: 1,
        name: "John",
        message: "Hello",
        incoming: true,
        created: DateTime.now()),
    ChatModel(
        id: 1,
        name: "John",
        message: "How are you?",
        incoming: true,
        created: DateTime.now()),
    ChatModel(
        id: 2,
        name: "Chris",
        message: "Hi, I'm fine, thanks!",
        incoming: false,
        isSent: true,
        created: DateTime.now()),
  ];

  Future<List<ChatModel>> getChatList([int? id]) async {
    return _chatList;
  }

  Future<BlocResponse<ChatModel>> addChat(ChatModel chat) async {
    await Future.delayed(const Duration(seconds: 1));
    // return true if the item was added successfully
    return Future.value(BlocResponse<ChatModel>(success: true, data: chat));
  }

  Future<List<TodoModel>> getTodoList([int? id]) async {
    await Future.delayed(const Duration(seconds: 1));
    return _todoList;
  }

  Future<BlocResponse<TodoModel>> addTodo(TodoModel todo) async {
    await Future.delayed(const Duration(seconds: 1));
    // return true if the item was added successfully

    return Future.value(BlocResponse<TodoModel>(
        success: true, data: todo, message: "Added todo"));
  }

  Future<BlocResponse<TodoModel>> deleteTodo(TodoModel todo) async {
    await Future.delayed(const Duration(seconds: 1));
    _todoList.remove(todo);
    // return true if the item was deleted successfully
    return Future.value(BlocResponse<TodoModel>(
        success: true, data: todo, message: "Deleted todo"));
  }

  Future<BlocResponse<TodoModel>> updateTodo(TodoModel todo) async {
    await Future.delayed(const Duration(seconds: 1));
    // return true if the item was updated successfully
    return Future.value(BlocResponse<TodoModel>(
        success: true, data: todo, message: "Updated todo"));
  }
}
