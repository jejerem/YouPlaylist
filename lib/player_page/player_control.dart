import 'package:flutter/material.dart';
import 'package:you_play_list/player_page/music_slider_section.dart';
import 'package:you_play_list/player_page/playing_music_title.dart';

import 'music_control_button_section.dart';

class PlayerControl extends StatefulWidget {
  const PlayerControl({Key? key}) : super(key: key);

  @override
  _PlayerControlState createState() => _PlayerControlState();
}

class _PlayerControlState extends State<PlayerControl> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlayingMusicTitle(),
        MusicSliderSection(),
        MusicControlButtonSection(),
      ],
    );
  }
}
