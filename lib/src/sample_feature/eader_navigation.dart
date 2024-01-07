import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/sample_feature/categoryWidge.dart';
import 'package:flutter_application_1/src/sample_feature/categorytabs.dart';
import 'Category.dart';

class HeaderNavigation extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<HeaderNavigation> createState() => _HeaderNavigationState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderNavigationState extends State<HeaderNavigation> {
  // Declare the `categories` list to store the categories
  List<String> categories = Category.names.toSet().toList();

  void addCategory(String category) {
    if (!categories.contains(category)) {
      categories.add(category);
      Category.saveCategories();

      // Notify the Flutter framework about the state change
      setState(() {});

      // Create a new category items widget

      // Update the Tabs with the new category items widget
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CategoryTabs(
            categories: Category.names,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('This category already exists.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

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
                  actions: [
                    TextButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        final categoryText = categoryController.text;
                        Category.names.add(categoryText);
                        // Rebuild the CategoryTabs page
                        setState(() {});
                        Category.saveCategories();
                        // Create the new category items widget

                        // Update the Tabs with the new category items widget
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.of(context).pop();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CategoryTabs(
                              categories: Category.names,
                            ),
                          ),
                        );
                      },
                    ),
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
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
}
