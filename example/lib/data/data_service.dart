import 'package:bloc_list/bloc_list.dart';
import 'package:example/models/chat_model.dart';
import 'package:example/models/todo_model.dart';

class DataService {
  final List<TodoModel> _todoList = [];

  List<ChatModel> _chatList = [];

  Future<List<ChatModel>> getChatList([int? id]) async {
    _chatList = [
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

    return _chatList;
  }

  Future<BlocResponse<ChatModel>> addChat(ChatModel chat) async {
    await Future.delayed(const Duration(seconds: 1));
    // return true if the item was added successfully
    return Future.value(BlocResponse<ChatModel>(success: true, data: chat));
  }

  Future<bool> deleteChat(ChatModel todo) async {
    await Future.delayed(const Duration(seconds: 1));
    // return true if the item was deleted successfully
    return Future.value(true);
  }

  Future<List<TodoModel>> getTodoList([int? id]) async {
    await Future.delayed(const Duration(seconds: 1));
    return _todoList;
  }

  Future<BlocResponse<TodoModel>> addTodo(TodoModel todo) async {
    await Future.delayed(const Duration(seconds: 1));
    // return true if the item was added successfully
    return Future.value(BlocResponse<TodoModel>(success: true, data: todo));
  }

  Future<bool> deleteTodo(TodoModel todo) async {
    await Future.delayed(const Duration(seconds: 1));
    // return true if the item was deleted successfully
    return Future.value(true);
  }

  Future<bool> updateTodo(TodoModel todo) async {
    await Future.delayed(const Duration(seconds: 1));
    // return true if the item was updated successfully
    return Future.value(true);
  }
}
