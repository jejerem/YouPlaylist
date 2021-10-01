import 'dart:async';

import 'package:flutter/material.dart';
import 'package:you_play_list/main.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:sizer/sizer.dart';

class MusicFABControlButtons extends StatefulWidget {
  const MusicFABControlButtons({Key? key}) : super(key: key);

  @override
  _MusicFABControlButtonsState createState() => _MusicFABControlButtonsState();
}

class _MusicFABControlButtonsState extends State<MusicFABControlButtons> {
  Timer? timer;
  bool isPlaying = true;
  late final Stream streamControllerButtons;

  @override
  void initState() {
    super.initState();

    streamControllerButtons = PlayerUpdate.streamControllerButtons.stream;
    streamControllerButtons.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.skip_previous,
              color: Colors.black,
              size: 2.h,
            ),
            onPressed: () {
              if (PlayerUpdate.assetsAudioPlayer!.current.valueOrNull != null) {
                PlayerUpdate.playPreviousVideo();
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (PlayerUpdate.assetsAudioPlayer!.current.hasValue) {
                if (PlayerUpdate.isStopped) {
                  PlayerUpdate.isStopped = false;
                }

                PlayerUpdate.assetsAudioPlayer!.playOrPause();
                setState(() {
                  PlayerUpdate.isPlaying =
                      PlayerUpdate.isPlaying ? false : true;
                });
              }
            },
            child: Container(
              child: Icon(
                !PlayerUpdate.assetsAudioPlayer!.current.hasValue
                    ? Icons.play_arrow
                    : PlayerUpdate.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                color: Colors.black,
                size: 2.h,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: CircleBorder(),
              side: BorderSide(
                width: 0.1.h,
                color: Colors.grey,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.skip_next,
              color: Colors.black,
              size: 2.h,
            ),
            onPressed: () {
              if (PlayerUpdate.assetsAudioPlayer!.current.valueOrNull != null) {
                PlayerUpdate.playNextVideo();
              }
            },
          ),
        ],
      ),
    );
  }
}
