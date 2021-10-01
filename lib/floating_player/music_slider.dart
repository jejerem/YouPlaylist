import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:sizer/sizer.dart';

import '../assets_youtube_player.dart';

class MusicSliderSection extends StatefulWidget {
  const MusicSliderSection({Key? key}) : super(key: key);

  @override
  _MusicSliderSectionState createState() => _MusicSliderSectionState();
}

class _MusicSliderSectionState extends State<MusicSliderSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 0.25.h,
        width: 83.w,
        child: PlayerBuilder.currentPosition(
            player: PlayerUpdate.assetsAudioPlayer!,
            builder: (context, duration) {
              if (PlayerUpdate.assetsAudioPlayer!.current.valueOrNull != null &&
                  PlayerUpdate.assetsYoutubePlayer!.inPlaylist) {
                double totalDuration = PlayerUpdate
                    .assetsAudioPlayer!.current.value!.audio.duration.inSeconds
                    .toDouble();
                if (totalDuration * 99 / 100 <= duration.inSeconds.toDouble()) {
                  PlayerUpdate.assetsYoutubePlayer!.onFinished(false);
                }
              }

              return LinearProgressIndicator(
                color: Colors.red,
                value:
                    PlayerUpdate.assetsAudioPlayer!.current.valueOrNull != null
                        ? duration.inSeconds.toDouble() /
                            PlayerUpdate.assetsAudioPlayer!.current.value!.audio
                                .duration.inSeconds
                                .toDouble()
                        : 0.0,
              );
            }));
  }
}
