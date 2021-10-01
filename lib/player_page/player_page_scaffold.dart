import 'package:flutter/material.dart';
import 'player_page.dart';
import 'package:sizer/sizer.dart';

class PlayerPageScaffold extends StatefulWidget {
  const PlayerPageScaffold({Key? key}) : super(key: key);

  @override
  _PlayerPageScaffoldState createState() => _PlayerPageScaffoldState();
}

class _PlayerPageScaffoldState extends State<PlayerPageScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () {},
            child: RawMaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              elevation: 1.0,
              fillColor: Colors.white.withOpacity(0.5),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
                size: 5.h,
              ),
              shape: CircleBorder(),
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: PlayerPage());
  }
}
