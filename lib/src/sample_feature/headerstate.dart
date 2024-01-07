import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/sample_feature/Category.dart';
import 'package:flutter_application_1/src/sample_feature/categorytabs.dart';

class HeaderNavigation extends StatefulWidget {
  @override
  _HeaderNavigationState createState() => _HeaderNavigationState();
}

class _HeaderNavigationState extends State<HeaderNavigation> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => CategoryTabs(
                categories: Category.names.toSet().toList(),
              ), // Replace with your tabbed page widget
            ));
          },
        ),
      ],
    );
  }
}
