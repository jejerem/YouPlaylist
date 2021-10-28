import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_play_list/player_page/player_update.dart';

class SettingsUpdate with ChangeNotifier {
  static ThemeMode currentTheme = ThemeMode.system;
  static String currentThemeChoice = "System";
  static late SharedPreferences prefs;

  static Future<void> getThemePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'theme';
    SettingsUpdate.currentThemeChoice = prefs.getString(key) ?? "System";
  }

  static Future<void> changeTheme() async {
    switch (currentThemeChoice) {
      case "Dark":
        {
          SettingsUpdate.currentTheme = ThemeMode.dark;
          break;
        }
      case "Light":
        {
          SettingsUpdate.currentTheme = ThemeMode.light;
          break;
        }
      default:
        {
          SettingsUpdate.currentTheme = ThemeMode.system;
          break;
        }
    }
  }

  static Future<void> waitRefreshThemePreferences() async {
    await getThemePreferences();
    await changeTheme();
  }

  void readThemePreferences() async {
    getThemePreferences();
    refreshTheme();
  }

  void refreshTheme() async {
    var previousTheme = currentTheme;
    changeTheme();
    var brightness = SchedulerBinding.instance!.window.platformBrightness;

    bool isLightToLight = false;
    bool isDarkToDark = false;

    if (brightness == Brightness.light) {
      isLightToLight = (previousTheme == ThemeMode.light ||
              previousTheme == ThemeMode.system) &&
          (currentTheme == ThemeMode.light || currentTheme == ThemeMode.system);
    } else {
      isDarkToDark = (previousTheme == ThemeMode.dark ||
              previousTheme == ThemeMode.system) &&
          (currentTheme == ThemeMode.dark || currentTheme == ThemeMode.system);
    }

    if (!isDarkToDark && !isLightToLight) {
      if (PlayerUpdate.webViewController != null) {
        PlayerUpdate.webViewController!.reload();
        notifyListeners();
      }
    }
  }
}
