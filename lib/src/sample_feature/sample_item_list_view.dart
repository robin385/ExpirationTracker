import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/sample_feature/notificationService.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'sample_item.dart';
import 'eader_navigation.dart';
import 'Category.dart';
import 'itemController.dart';

class SampleItemListView extends StatefulWidget {
  static const routeName = '/sampleItemListView';

  @override
  _SampleItemListViewState createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  List<SampleItem> items = [];
  final TextEditingController nameController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<String> categories = ['cat1'];
  String? selectedCategory;

  Future<void> loadCategories() async {
    categories = await Category.loadCategories();
    await ItemController.loadItems();
    setState(() {
      items = List.from(ItemController.items);
    });
  }

  @override
  void dispose() {
    saveCategories();
    super.dispose();
  }

  Future<void> saveCategories() async {
    await ItemController.saveItems();
    await Category.saveCategories();
  }

  @override
  void initState() {
    super.initState();
    loadCategories();
    _loadItems();
  }

  Future<void> _loadItems() async {
    await ItemController.loadItems();
    setState(() {
      items = List.from(ItemController.items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderNavigation(),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  NotificationService.cancelNotification(
                      items[index].name.hashCode);
                  items.removeAt(index);
                  ItemController.items = List.from(items);
                  saveCategories();
                });
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(items[index].name,
                        style: Theme.of(context).textTheme.subtitle1),
                    Text(
                      items[index].category,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
                Text(
                  '${items[index].date.day}.${items[index].date.month}.${items[index].date.year}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 20.0, // Maximum height of the dialog
                  maxWidth: 300.0, // Maximum width of the dialog
                ),
                child: AlertDialog(
                  title: const Text('Add a new item'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(hintText: "Enter name"),
                      ),
                      DropdownButton<String>(
                        value: selectedCategory,
                        hint: const Text('Select a category'),
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        items: categories
                            .where((category) => category != 'Home')
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null && picked != selectedDate) {
                            setState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: const Text("Select date"),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Add'),
                      onPressed: () {
                        setState(() {
                          items.add(SampleItem(nameController.text,
                              selectedDate, selectedCategory!));
                          ItemController.items = List.from(items);

                          if (DateTime.now().difference(selectedDate).inDays >
                              5) {
                            DateTime newDate =
                                selectedDate.subtract(const Duration(days: 5));
                            NotificationService.scheduleNotification(
                                newDate, "EXPIRATION", nameController.text);
                          }
                          saveCategories();
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
