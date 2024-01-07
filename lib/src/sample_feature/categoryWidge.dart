import 'package:flutter/material.dart';
import 'sample_item.dart';
import 'eader_navigation.dart';
import 'Category.dart';
import 'itemController.dart';

class CategoryItemsWidget extends StatefulWidget {
  final String category;

  CategoryItemsWidget({required this.category});

  @override
  _CategoryItemsWidgetState createState() => _CategoryItemsWidgetState();
}

class _CategoryItemsWidgetState extends State<CategoryItemsWidget> {
  List<SampleItem> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    await ItemController.loadItems();
    setState(() {
      items = ItemController.getItemsByCategory(widget.category);
    });
  }

  void _deleteCategory() {
    setState(() {
      ItemController.deleteCategory(widget.category);
      Category.deleteCategory(widget.category);
      items = ItemController.getItemsByCategory(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // This is the header
          return ListTile(
            title: Text('delete ${widget.category}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteCategory,
            ),
          );
        } else {
          final item = items[index - 1];
          // Replace with your actual UI for each item
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(items[index - 1].name,
                        style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
                Text(
                  '${items[index - 1].date.day}.${items[index - 1].date.month}.${items[index - 1].date.year}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
