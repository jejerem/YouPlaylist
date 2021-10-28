import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_play_list/constants/values.dart';
import 'package:you_play_list/navigation_drawer/settings_update.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

//https://stackoverflow.com/questions/57267932/how-can-i-prevent-my-build-method-from-looping
class _SettingsPageState extends State<SettingsPage> {
  void saveThemePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'theme';
    prefs.setString(key, SettingsUpdate.currentThemeChoice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Container(
            alignment: Alignment.topLeft,
            child: Row(children: [
              Text("Theme mode : ", style: Constants.defaultFont),
              DropdownButton<String>(
                value: SettingsUpdate.currentThemeChoice,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    SettingsUpdate.currentThemeChoice = newValue!;
                    saveThemePreferences();
                    Provider.of<SettingsUpdate>(context, listen: false)
                        .readThemePreferences();
                  });
                },
                items: <String>["System", "Dark", "Light"]
                    .map<DropdownMenuItem<String>>((String value) {
                  var valueIcon = value == "Light"
                      ? Icon(Icons.brightness_5)
                      : value == "Dark"
                          ? Icon(Icons.brightness_3)
                          : Icon(Icons.construction);
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Row(children: [
                        Text(value, style: Constants.defaultFont),
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: valueIcon)
                      ]));
                }).toList(),
              )
            ])));
  }
}
