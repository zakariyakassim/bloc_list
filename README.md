## Getting started

A flexible and customizable list widget for Flutter applications using the BLoC pattern for state management. It offers dynamic data loading, state-dependent rendering, custom loader support, and error handling, ideal for creating responsive and user-friendly list views.

## Usage

TODO: Quick examples

<p align="center">
<img src="https://github.com/zakariyakassim/bloc_list/blob/main/screenshots/chat_preview.gif?raw=true" width="300"/>

<img src="https://github.com/zakariyakassim/bloc_list/blob/main/screenshots/todo_preview.gif?raw=true" width="300"/>
</p>

<p>Using flutter_bloc</p>

```dart
void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => TodoBloc(DataService())),
    ],
    child: const MainApp(),
  ));
}
```

```dart
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
          onItemError: (errorType, item, errorMessage) {
            item.isBusy = false;
            _displaySnackBar(context, errorMessage);
          },
          onItemAdding: (addingItem) {
            addingItem.isBusy = true;
          },
          onItemDeleting: (deletingItem) {
            deletingItem.isBusy = true;
          },
          onItemUpdating: (newItem, oldItem) {
            oldItem.isBusy = true;
          },
          onItemDeleted: (deletedItem) {
            _displaySnackBar(context, "Deleted ${deletedItem.description}");
          },
          onItemUpdated: (newItem, oldItem) {
            _displaySnackBar(context,
                "Updated ${oldItem.description} to ${newItem.description}");
          },
          onItemAdded: (addedItem) {
            addedItem.isBusy = false;
            _displaySnackBar(context, "Added ${addedItem.description}");
          },
          itemBuilder: (context, index, item) {
            // var added = item.id != null;

            var outputFormat = DateFormat('dd MMM yyyy HH:mm');
            var date = outputFormat.format(item.created);

            return ListTile(
              title: Text(
                item.description,
                style:
                    TextStyle(color: item.isBusy ? Colors.grey : Colors.black),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit,
                        color: item.isBusy ? Colors.grey : Colors.black),
                    onPressed: () {
                      _addOrUpdateTodoItem(context, index: index, item: item);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete,
                        color: item.isBusy ? Colors.grey : Colors.black),
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
                child: Text(
                  date,
                  style: TextStyle(
                      color: item.isBusy ? Colors.grey : Colors.black54),
                ),
              ),
            );
          },
          loadData: () async {
            BlocProvider.of<TodoBloc>(context).add(LoadDataEvent());
          },
          stateCondition: (state) => state,
        ));
  }
```

```dart
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
```
