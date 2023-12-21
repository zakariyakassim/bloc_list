## Getting started

TODO: A flexible and customizable list widget for Flutter applications using the BLoC pattern for state management. It offers dynamic data loading, state-dependent rendering, custom loader support, and error handling, ideal for creating responsive and user-friendly list views.

## Usage

TODO: Quick examples


```dart
  @override
  Widget build(BuildContext context) {
    return BlocList<AnnouncementModel, AnnouncementBloc, ListState>(
      title: "My todo list",
        emptyBuilder: (context, state) {
            return const Center(child: Text('Todo is empty'));
        },
      loadBuilder: (context, state) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        ));
      },
      itemBuilder: (context, index, item) {
        var description = item.description.trim();
        var outputFormat = DateFormat('dd MMM yyyy HH:mm');
        var date = outputFormat.format(item.created);
        return ListTile(
          title: Text(description),
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
    );
  }
```

```dart
class TodoBloc extends ListBloc<TodoModel> {
  TodoBloc(this.firebaseService)
      : super(
          dataProvider: () => [],
        );
}
```