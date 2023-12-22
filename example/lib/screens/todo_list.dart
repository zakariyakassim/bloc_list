import 'package:bloc_list/bloc_list.dart';
import 'package:example/blocs/todo_bloc.dart';
import 'package:example/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Todo List')),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () => _addOrUpdateTodoItem(context),
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: BlocList<TodoModel, TodoBloc, ListState>(
          emptyBuilder: (context, state) {
            return const Center(child: Text('Please add a todo item'));
          },
          loadBuilder: (context, state) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black,
            ));
          },
          onItemDeleted: (deletedItem) {
            _displaySnackBar(context, "Deleted ${deletedItem.description}");
          },
          onItemUpdated: (newItem, oldItem) {
            Navigator.pop(context);
            _displaySnackBar(context,
                "Updated ${oldItem.description} to ${newItem.description}");
          },
          onItemAdded: (addedItem) {
            Navigator.pop(context);
            _displaySnackBar(context, "Added ${addedItem.description}");
          },
          itemBuilder: (context, index, item) {
            var outputFormat = DateFormat('dd MMM yyyy HH:mm');
            var date = outputFormat.format(item.created);

            return ListTile(
              title: Text(item.description),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _addOrUpdateTodoItem(context, index: index, item: item);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteDialog(context, () {
                        BlocProvider.of<TodoBloc>(context)
                            .add(DeleteDataEvent(item));
                      });
                    },
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(date),
              ),
            );
          },
          loadData: () async {
            BlocProvider.of<TodoBloc>(context).add(LoadDataEvent());
          },
          stateCondition: (state) => state,
        ));
  }

  _addOrUpdateTodoItem(BuildContext context, {TodoModel? item, int? index}) {
    var descriptionController = TextEditingController();

    if (item != null) {
      descriptionController.text = item.description;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(item == null ? 'Add Todo' : 'Update Todo'),
            content: TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: "Description"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (item == null) {
                    BlocProvider.of<TodoBloc>(context).add(AddDataEvent(
                        TodoModel(
                            id: 1, description: descriptionController.text)));
                  } else if (index != null) {
                    BlocProvider.of<TodoBloc>(context).add(UpdateDataEvent(
                        oldItem: item,
                        newItem: TodoModel(
                            id: item.id,
                            description: descriptionController.text)));
                  }
                },
                child: Text(item == null ? 'Add' : 'Update'),
              ),
            ],
          );
        });
  }

  _displaySnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
    ));
  }

  _deleteDialog(BuildContext context, Function onDelete) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text('Are you sure you want to delete this?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  onDelete();
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }
}
