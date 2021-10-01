import 'dart:async';
import 'package:flutter/material.dart';
import 'package:you_play_list/player_page/images_section.dart';
import 'package:you_play_list/player_page/player_control.dart';
import 'package:you_play_list/player_page/player_update.dart';

class PlayerPage extends StatefulWidget {
  PlayerPage({Key? key}) : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    Stream<int> stream = PlayerUpdate.streamControllerPlayerPage.stream;

    stream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ImagesSection(),
            PlayerControl(),
          ],
        ));
  }
}
