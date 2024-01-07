import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/sample_feature/categoryWidge.dart';
import 'package:flutter_application_1/src/sample_feature/sample_item_list_view.dart';
import 'Category.dart';

class CategoryTabs extends StatefulWidget {
  final List<String> categories;

  const CategoryTabs({required this.categories});

  @override
  _CategoryTabsState createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: categories.length);
    loadCategories();
  }

  Future<void> loadCategories() async {
    categories = await Category.loadCategories();
    _tabController = TabController(vsync: this, length: categories.length);
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namirnice i rokovi'),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: categories.map((String category) {
            return Tab(text: category);
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((String category) {
          if (category == 'Home') {
            return Center(child: SampleItemListView());
          }
          return CategoryItemsWidget(category: category);
        }).toList(),
      ),
    );
  }
}
