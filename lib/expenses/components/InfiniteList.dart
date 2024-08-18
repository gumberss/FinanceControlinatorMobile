import 'package:flutter/material.dart';

typedef RequestFn<T> = Future<List<T>> Function(int page, int count);
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

class InifiniteList<T> extends StatefulWidget {
  final RequestFn<T> onRequest;
  final ItemBuilder<T> itemBuilder;
  final int itensPerPage;

  const InifiniteList(
      {super.key,
      required this.onRequest,
      required this.itemBuilder,
      required this.itensPerPage});

  @override
  _InifiniteListState<T> createState() => _InifiniteListState<T>();
}

class _InifiniteListState<T> extends State<InifiniteList<T>> {
  List<T> items = [];
  bool end = false;

  _getMoreItems() async {
    var page = (items.length / widget.itensPerPage).ceil() + 1;
    final moreItems = await widget.onRequest(page, widget.itensPerPage);
    if (!mounted) return;

    if (moreItems.isEmpty) {
      setState(() => end = true);
      return;
    }
    setState(() => items = [...items, ...moreItems]);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < items.length) {
          return widget.itemBuilder(context, items[index], index);
        } else if (index == items.length && end) {
          return const Center(child: Text('End of list'));
        } else {
          _getMoreItems();
          return const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
      itemCount: items.length + 1,
    );
  }
}
