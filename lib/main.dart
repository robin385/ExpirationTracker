import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/sample_feature/Category.dart';
import 'package:flutter_application_1/src/sample_feature/notificationService.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
    WidgetsFlutterBinding.ensureInitialized();
var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
  final settingsController = SettingsController(SettingsService());
  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();
    final prefs = await SharedPreferences.getInstance();
  var temp = await Category.loadCategories();
  List<String> categories = List.from(temp.toList());
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  // Initialize the notification plugin
await NotificationService.initialize();

// Schedule a notification
  runApp(MyApp(
    settingsController: settingsController,
    categories: categories,
  ));
}
