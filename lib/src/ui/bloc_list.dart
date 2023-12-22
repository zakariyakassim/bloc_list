import 'package:bloc_list/src/blocs/list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocList<T, B extends BlocBase<S>, S> extends StatefulWidget {
  final Widget Function(BuildContext, int, T)? itemBuilder;
  final Function loadData;
  final S Function(S) stateCondition;
  final Widget Function(BuildContext, S, List<T>?)? alternateBuilder;
  final Widget Function(BuildContext, S)? emptyBuilder;
  final Widget Function(BuildContext, S)? loadBuilder;
  final Function(T deletedItem)? onItemDeleted;
  final Function(T addedItem)? onItemAdded;
  final Function(T newItem, T oldItem)? onItemUpdated;

  const BlocList({
    super.key,
    this.itemBuilder,
    required this.loadData,
    required this.stateCondition,
    this.alternateBuilder,
    this.emptyBuilder,
    this.loadBuilder,
    this.onItemDeleted,
    this.onItemAdded,
    this.onItemUpdated,
  });

  @override
  State<BlocList<T, B, S>> createState() => _BlocListState<T, B, S>();
}

class _BlocListState<T, B extends BlocBase<S>, S>
    extends State<BlocList<T, B, S>> {
  List<T>? items;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(listener: (context, state) {
      if (widget.stateCondition(state) is DataDeleted<T>) {
        var deletedState = widget.stateCondition(state) as DataDeleted;
        if (widget.onItemDeleted != null) {
          widget.onItemDeleted!(deletedState.item);
        }
      }
      if (widget.stateCondition(state) is DataAdded<T>) {
        var addedState = widget.stateCondition(state) as DataAdded;
        if (widget.onItemAdded != null) {
          widget.onItemAdded!(addedState.item);
        }
      }
      if (widget.stateCondition(state) is DataUpdated<T>) {
        var updatedState = widget.stateCondition(state) as DataUpdated;
        if (widget.onItemUpdated != null) {
          widget.onItemUpdated!(updatedState.newItem, updatedState.oldItem);
        }
      }
    }, child: BlocBuilder<B, S>(
      builder: (context, state) {
        isLoading =
            widget.stateCondition(state) is ListLoading && items == null;

        if (widget.stateCondition(state) is ListLoaded<T>) {
          var loadedState = widget.stateCondition(state) as ListLoaded<T>;
          items = loadedState.items;
        }

        return RefreshIndicator(
            onRefresh: () async => widget.loadData(), child: content(state));
      },
    ));
  }

  Widget content(S state) {
    if (items != null && items!.isEmpty) {
      return emptyBuilder(state);
    }

    if (items != null && widget.alternateBuilder != null) {
      return widget.alternateBuilder!(context, state, items);
    } else if (items != null && widget.alternateBuilder == null) {
      return _listViewWidget(state);
    } else {
      return _loadingOrErrorWidget(state);
    }
  }

  Widget emptyBuilder(S state) {
    if (widget.emptyBuilder != null) {
      return widget.emptyBuilder!(context, state);
    } else {
      return Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            const Text('No Data',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.loadData();
              },
              child: const Text('Refresh'),
            )
          ]));
    }
  }

  Widget _listViewWidget(S state) {
    return ListView.builder(
      itemCount: items!.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < items!.length) {
          return widget.itemBuilder != null
              ? widget.itemBuilder!(context, index, items![index])
              : const Text('No item builder defined');
        } else {
          return _loadingOrErrorWidget(state);
        }
      },
    );
  }

  Widget _loadingOrErrorWidget(S state) {
    if (widget.stateCondition(state) is ListError) {
      var errorState = widget.stateCondition(state) as ListError;
      return Center(child: Text('Error: ${errorState.message}'));
    }

    if (widget.loadBuilder != null) {
      return widget.loadBuilder!(context, state);
    } else {
      return const Center(
          child: CircularProgressIndicator(
        color: Colors.red,
      ));
    }
  }
}
