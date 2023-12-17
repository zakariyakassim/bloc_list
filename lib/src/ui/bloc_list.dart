import 'package:bloc_list/src/blocs/list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocList<T, B extends BlocBase<S>, S> extends StatefulWidget {
  final String title;
  final Widget Function(BuildContext, int, T)? itemBuilder;
  final Function loadData;
  final S Function(S) stateCondition;
  final Widget Function(BuildContext, S, List<T>?)? alternateBuilder;
  final Widget? emptyBuilder;
  final Widget? loadingBuilder;

  const BlocList({
    super.key,
    this.itemBuilder,
    required this.loadData,
    required this.title,
    required this.stateCondition,
    this.alternateBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BlocBuilder<B, S>(
        builder: (context, state) {
          isLoading =
              widget.stateCondition(state) is ListLoading && items == null;

          if (widget.stateCondition(state) is ListLoaded<T>) {
            var loadedState = widget.stateCondition(state) as ListLoaded<T>;
            items = loadedState.items;
          }

          // Wrap the UI with RefreshIndicator
          return RefreshIndicator(
            onRefresh: () async => widget.loadData(),
            child: widget.alternateBuilder != null && items != null
                ? widget.alternateBuilder!(context, state, items)
                : items != null
                    ? _listViewWidget(state)
                    : items != null && items!.isEmpty
                        ? emptyBuilder()
                        : _loadingOrErrorWidget(state),
          );
        },
      ),
    );
  }

  Widget emptyBuilder() {
    // if (items!.isEmpty) {
    return widget.emptyBuilder != null
        ? widget.emptyBuilder!
        : const Center(child: Text('No items found'));
    // }
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
          return _bottomLoader();
        }
      },
    );
  }

  Widget _bottomLoader() {
    return isLoading
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : const SizedBox.shrink();
  }

  Widget _loadingOrErrorWidget(S state) {
    if (widget.stateCondition(state) is ListError) {
      var errorState = widget.stateCondition(state) as ListError;
      return Center(child: Text('Error: ${errorState.message}'));
    }
    return const Center(child: CircularProgressIndicator());
  }
}
