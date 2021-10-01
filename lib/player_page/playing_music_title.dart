import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:sizer/sizer.dart';
import 'package:marquee_widget/marquee_widget.dart';

class PlayingMusicTitle extends StatefulWidget {
  const PlayingMusicTitle({Key? key}) : super(key: key);

  @override
  _PlayingMusicTitleState createState() => _PlayingMusicTitleState();
}

class _PlayingMusicTitleState extends State<PlayingMusicTitle> {
  late Stream streamControllerTitles;

  @override
  Widget build(BuildContext context) {
    PlayerUpdate.loadSaveTitleInfos();
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      child: Column(
        children: [
          Marquee(
            autoRepeat: true,
            child: Text(
              PlayerUpdate.videoTitle,
              maxLines: 1,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w700,
                fontSize: 12.0.sp,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 3),
          Marquee(
            autoRepeat: true,
            child: Text(
              PlayerUpdate.channelName,
              maxLines: 1,
              style: GoogleFonts.lato(
                fontWeight: FontWeight.w400,
                fontSize: 12.0.sp,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
