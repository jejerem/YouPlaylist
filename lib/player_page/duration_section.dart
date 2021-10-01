import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:you_play_list/player_page/player_update.dart';

class DurationSection extends StatefulWidget {
  const DurationSection({Key? key}) : super(key: key);

  @override
  _DurationSectionState createState() => _DurationSectionState();
}

class _DurationSectionState extends State<DurationSection> {
  String? videoDuration;

  @override
  Widget build(BuildContext context) {
    if (PlayerUpdate.assetsAudioPlayer!.current.valueOrNull != null) {
      videoDuration = PlayerUpdate
          .assetsAudioPlayer!.current.value!.audio.duration
          .toString()
          .substring(0, 7);
    }

    if (videoDuration == null) {
      videoDuration = PlayerUpdate.videoDuration.toString().substring(0, 7);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display current duration.
          // Best solution to avoid shifting with the current duration.
          PlayerBuilder.currentPosition(
              player: PlayerUpdate.assetsAudioPlayer!,
              builder: (context, duration) {
                return Text(duration.toString().substring(0, 7),
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ));
              }),
          // Display video duration.
          Text(
            videoDuration!,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
