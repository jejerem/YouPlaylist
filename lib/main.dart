import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:you_play_list/bottom_navigation_bar/bottom_navigation_bar_content.dart';
import 'package:you_play_list/webview_interactions/webview_ytb.dart';
import 'floating_player/floatingPlayerButton.dart';

StreamController<int> streamController = StreamController<int>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new YouPlaylist());
  });
}

class YouPlaylist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.grey,
    ));

    return MaterialApp(
        title: "YouPlaylist",
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green,
        ),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
  }
}
