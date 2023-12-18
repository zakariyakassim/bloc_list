<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).


TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.
-->

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

<!-- ## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more. -->
