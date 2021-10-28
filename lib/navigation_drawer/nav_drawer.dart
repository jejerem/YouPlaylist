import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:you_play_list/constants/values.dart';
import 'package:you_play_list/navigation_drawer/credits_page.dart';
import 'package:you_play_list/navigation_drawer/settings_page.dart';

class NavDrawer extends StatelessWidget {
  void transition(BuildContext context, var page) {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (c, a1, a2) => page,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              final tween = Tween(begin: begin, end: end);
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: curve,
              );

              return SlideTransition(
                position: tween.animate(curvedAnimation),
                child: child,
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: DrawerHeader(
                child: null,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: Constants.cover_side_menu)),
              )),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {transition(context, SettingsPage())},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Credits'),
            onTap: () => {transition(context, CreditsPage())},
          ),
        ],
      ),
    );
  }
}
