import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:you_play_list/app_style/app_theme.dart';
import 'package:you_play_list/bottom_navigation_bar/bottom_navigation_bar_content.dart';
import 'package:you_play_list/main_menu_app_bar.dart';
import 'package:you_play_list/navigation_drawer/nav_drawer.dart';
import 'package:you_play_list/navigation_drawer/settings_update.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:you_play_list/webview_interactions/webview_ytb.dart';
import 'package:provider/provider.dart';

import 'floating_player/floatingPlayerButton.dart';

StreamController<int> streamController = StreamController<int>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SettingsUpdate.waitRefreshThemePreferences();
  print(SettingsUpdate.currentTheme);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ChangeNotifierProvider<SettingsUpdate>(
      create: (_) => SettingsUpdate(),
      child: YouPlaylist(),
    ));
  });
}

//Fix the next problem when out of app (crashes after two next)
class YouPlaylist extends StatelessWidget {
  const YouPlaylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.grey,
    ));

    return Consumer<SettingsUpdate>(builder: (context, appState, child) {
      return MaterialApp(
          title: "YouPlaylist",
          theme: AppTheme.lightTheme,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.green,
          ),
          themeMode: SettingsUpdate.currentTheme,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            drawer: NavDrawer(),
            appBar: AppBar(
                actions: [
                  RawMaterialButton(
                    onPressed: () async {
                      await PlayerUpdate.webViewController!
                          .evaluateJavascript("""
            profileElements = document.getElementsByClassName('icon-button topbar-menu-button-avatar-button');
            if (profileElements.length == 2){
              profileElements[1].click();
            }
            """);
                    },
                    elevation: 2.0,
                    child: Icon(
                      Icons.account_circle,
                      size: 30,
                    ),
                    shape: CircleBorder(),
                  )
                ],
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    );
                  },
                ),
                title: MainMenuSilverAppBar()),
            body: WebViewYTB(),
            bottomNavigationBar: BottomNavigationBarContent(),
            floatingActionButton: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.bottomLeft,
                    child: FloattingPlayerButton())
              ],
            ),
          ));
    });
  }
}
