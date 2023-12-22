## Getting started

TODO: A flexible and customizable list widget for Flutter applications using the BLoC pattern for state management. It offers dynamic data loading, state-dependent rendering, custom loader support, and error handling, ideal for creating responsive and user-friendly list views.

## Usage

TODO: Quick examples


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
```

```dart
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
```