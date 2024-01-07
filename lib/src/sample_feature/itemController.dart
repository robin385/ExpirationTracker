import 'dart:io';
import 'dart:async';
import 'package:flutter_application_1/src/sample_feature/notificationService.dart';

import 'sample_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ItemController {
  static List<SampleItem> items = [];

  static Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsString = prefs.getString('items') ?? '[]';
    final itemsJson = jsonDecode(itemsString) as List;
    items = itemsJson.map((item) => SampleItem.fromJson(item)).toList();
  }

  static Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = items.map((item) => item.toJson()).toList();
    if (items.isNotEmpty) {}
    final itemsString = jsonEncode(itemsJson);
    prefs.setString('items', itemsString);
  }

  static List<SampleItem> getItemsByCategory(String category) {
    return items.where((item) => item.category == category).toList();
  }

  static void deleteCategory(String category) {
    items.where((item) => item.category == category).forEach((item) {
      NotificationService.cancelNotification(item.name.hashCode);
    });

    items.removeWhere((item) => item.category == category);
    saveItems();
  }
}
