import 'dart:async';

import 'package:flutter/material.dart';
import 'package:you_play_list/floating_player/music_control_buttons.dart';
import 'package:you_play_list/floating_player/thumbnail_section.dart';
import 'package:you_play_list/floating_player/title_section.dart';
import 'package:you_play_list/floating_player/music_slider.dart';
import 'package:you_play_list/player_page/player_update.dart';

class FloatingPlayerContent extends StatefulWidget {
  FloatingPlayerContent();

  @override
  _FloatingPlayerContentState createState() => _FloatingPlayerContentState();
}

class _FloatingPlayerContentState extends State<FloatingPlayerContent> {
  @override
  void initState() {
    super.initState();
    if (!PlayerUpdate.streamControllerFABPlayer.hasListener) {
      Stream<int> stream = PlayerUpdate.streamControllerFABPlayer.stream;

      stream.listen((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Row(children: [
        ThumbnailSection(),
        TitleFABSection(),
        MusicFABControlButtons()
      ]),
      MusicSliderSection()
    ]));
  }
}
