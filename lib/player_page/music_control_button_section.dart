import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:sizer/sizer.dart';

class MusicControlButtonSection extends StatefulWidget {
  const MusicControlButtonSection({Key? key}) : super(key: key);

  @override
  _MusicControlButtonSectionState createState() =>
      _MusicControlButtonSectionState();
}

class _MusicControlButtonSectionState extends State<MusicControlButtonSection> {
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
      margin: EdgeInsets.only(top: 1.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              padding: EdgeInsets.all(0),
              icon: PlayerUpdate.isShuffled
                  ? Icon(
                      Icons.shuffle,
                      color: Colors.blue,
                      size: 10.4.w,
                    )
                  : Icon(
                      Icons.shuffle,
                      color: Colors.grey,
                      size: 10.4.w,
                    ),
              onPressed: () {
                setState(() {
                  PlayerUpdate.assetsYoutubePlayer!.onShuffle();
                });
              }),
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.skip_previous,
              color: Colors.black,
              size: 10.4.w,
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

                setState(() {
                  PlayerUpdate.isPlaying =
                      PlayerUpdate.isPlaying ? false : true;
                  PlayerUpdate.assetsAudioPlayer!.playOrPause();
                });
                PlayerUpdate.streamControllerFABPlayer.add(1);
              }
            },
            child: Container(
              padding: EdgeInsets.all(3.w),
              child: Icon(
                !PlayerUpdate.assetsAudioPlayer!.current.hasValue
                    ? Icons.play_arrow
                    : PlayerUpdate.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                color: Colors.black,
                size: 10.4.w,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0),
              primary: Colors.white,
              shape: CircleBorder(),
              side: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.skip_next,
              color: Colors.black,
              size: 10.4.w,
            ),
            onPressed: () {
              if (PlayerUpdate.assetsAudioPlayer!.current.valueOrNull != null) {
                PlayerUpdate.playNextVideo();
              }
            },
          ),
          IconButton(
            padding: EdgeInsets.all(0),
            icon: PlayerUpdate.loopMode == LoopMode.none
                ? Icon(
                    Icons.repeat,
                    color: Colors.grey,
                    size: 10.4.w,
                  )
                : Icon(
                    Icons.repeat,
                    color: Colors.blue,
                    size: 10.4.w,
                  ),
            onPressed: () {
              setState(() {
                PlayerUpdate.switchLoopMode();
              });
            },
          ),
        ],
      ),
    );
  }
}
