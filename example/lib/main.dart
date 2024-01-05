import 'package:example/blocs/chat_bloc.dart';
import 'package:example/blocs/todo_bloc.dart';
import 'package:example/data/data_service.dart';
import 'package:example/screens/chat.dart';
import 'package:example/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => TodoBloc(DataService())),
      BlocProvider(create: (_) => ChatBloc(DataService())),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return const MaterialApp(home: TodoListPage());
    return const MaterialApp(home: HomePage());
  }
}
