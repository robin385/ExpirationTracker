import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/sample_feature/Category.dart';
import 'package:flutter_application_1/src/sample_feature/eader_navigation.dart';

class HeaderNavigationState extends State<HeaderNavigation> {
  // Declare the `categories` list to store the categories
  List<String> categories = Category.names.toSet().toList();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(''), // Remove the sample app title
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final categoryController = TextEditingController();
                return AlertDialog(
                  title: const Text('Add a new category'),
                  content: TextField(
                    controller: categoryController,
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        if (!categories.contains(categoryController.text)) {
                          categories.add(categoryController.text);
                          Category.saveCategories();

                          // Rebuild the CategoryTabs page
                          setState(() {});
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content:
                                  const Text('This category already exists.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  void addCategory(String category) {
    if (!categories.contains(category)) {
      categories.add(category);
      Category.saveCategories();

      // Notify the Flutter framework about the state change
      setState(() {});
    }
  }
}
