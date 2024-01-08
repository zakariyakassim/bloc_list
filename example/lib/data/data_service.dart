import 'dart:convert';

import 'package:bloc_list/bloc_list.dart';
import 'package:example/models/chat_model.dart';
import 'package:example/models/todo_model.dart';
import 'package:http/http.dart' as http;

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

  Future<BlocResponse<List<ChatModel>>> getChatList([int? id]) async {
    return Future.value(BlocResponse<List<ChatModel>>(
        success: true, data: _chatList, message: "Loaded chat"));
  }

  Future<BlocResponse<ChatModel>> addChat(ChatModel chat) async {
    await Future.delayed(const Duration(seconds: 1));
    // return true if the item was added successfully
    return Future.value(BlocResponse<ChatModel>(success: true, data: chat));
  }

  Future<BlocResponse<List<TodoModel>>> getTodoList([int? id]) async {
    await Future.delayed(const Duration(seconds: 1));
    return BlocResponse<List<TodoModel>>(success: true, data: _todoList);
  }

  // Future<BlocResponse<List<TodoModel>>> getTodoList([int? id]) async {
  //   final response = await http
  //       .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  //   if (response.statusCode == 200) {
  //     List<TodoModel> todos = (jsonDecode(response.body) as List<dynamic>)
  //         .map((e) => TodoModel.fromJson(e as Map<String, dynamic>))
  //         .toList();

  //     return BlocResponse<List<TodoModel>>(success: true, data: todos);
  //   } else {
  //     return BlocResponse<List<TodoModel>>(
  //         success: false, message: "Error loading todos");
  //   }
  // }

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
