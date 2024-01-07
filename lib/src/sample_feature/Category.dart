import 'package:shared_preferences/shared_preferences.dart';

class Category {
  static List<String> names = ["Home"];

  static Future<List<String>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final temp = (prefs.getStringList('categories') ?? []).toSet();
    names = temp.toList();
    if (names.contains("Home")) {
      names.remove("Home");
    }
    names.insert(0, "Home");
    return names;
  }

  static Future<void> saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('categories', names.toSet().toList());
  }

  static Future<void> deleteCategory(String categoryName) async {
    names.remove(categoryName);
    await saveCategories();
  }
}
