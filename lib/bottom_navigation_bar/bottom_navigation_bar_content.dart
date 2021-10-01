import 'dart:async';

import 'package:flutter/material.dart';
import 'package:you_play_list/player_page/player_update.dart';

import '../link.dart';

class BottomNavigationBarContent extends StatefulWidget {
  const BottomNavigationBarContent({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarContentState createState() =>
      _BottomNavigationBarContentState();
}

class _BottomNavigationBarContentState
    extends State<BottomNavigationBarContent> {
  Timer? timer;

  int _selectedIndex = 0;

  List<BottomNavigationBarItem> navigationItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.star),
      label: 'Trending',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.subscriptions),
      label: 'Subscriptions',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.video_library),
      label: 'Library',
    ),
  ];

  void selectHiddenItem(String index) async {
    await PlayerUpdate.webViewController!.evaluateJavascript("""
    
    var listItems = document.getElementsByTagName('ytm-pivot-bar-item-renderer');
    if (listItems.length != 0){
      try{
      listItems[$index].getElementsByTagName("div")[0].click();
      } catch(error){
      listItems[2].getElementsByTagName("div")[0].click();
      }
    }

    """);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    selectHiddenItem(index.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: navigationItems,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.indigoAccent,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
