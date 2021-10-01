import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:you_play_list/player_page/duration_section.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:sizer/sizer.dart';

import '../assets_youtube_player.dart';

class MusicSliderSection extends StatefulWidget {
  const MusicSliderSection({Key? key}) : super(key: key);

  @override
  _MusicSliderSectionState createState() => _MusicSliderSectionState();
}

class _MusicSliderSectionState extends State<MusicSliderSection> {
  Timer? timer;
  double? videoDuration;

  @override
  Widget build(BuildContext context) {
    if (PlayerUpdate.assetsAudioPlayer!.current.valueOrNull != null) {
      PlayerUpdate.videoDuration =
          PlayerUpdate.assetsAudioPlayer!.current.value!.audio.duration;
      videoDuration = PlayerUpdate.videoDuration.inSeconds.toDouble();
    }

    if (videoDuration == null) {
      videoDuration = PlayerUpdate.videoDuration.inSeconds.toDouble();
    }

    return Column(children: [
      Container(
          padding: EdgeInsets.symmetric(horizontal: 1.5.h),
          child: PlayerBuilder.currentPosition(
              player: PlayerUpdate.assetsAudioPlayer!,
              builder: (context, duration) {
                return Slider(
                    value: duration.inSeconds.toDouble(),
                    max: videoDuration!,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                    onChanged: (double newValue) {
                      if (PlayerUpdate.assetsAudioPlayer!.current.valueOrNull !=
                          null) {
                        setState(() {
                          PlayerUpdate.assetsAudioPlayer!
                              .seek(Duration(seconds: newValue.round()));
                        });
                      }
                    });
              })),
      DurationSection(),
    ]);
  }
}
