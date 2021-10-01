import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:sizer/sizer.dart';

class TitleFABSection extends StatefulWidget {
  const TitleFABSection({Key? key}) : super(key: key);

  @override
  _TitleSectionState createState() => _TitleSectionState();
}

class _TitleSectionState extends State<TitleFABSection> {
  late Stream streamControllerTitles;

  @override
  Widget build(BuildContext context) {
    PlayerUpdate.loadSaveTitleInfos();
    return Padding(
        padding: EdgeInsets.only(right: 3.w),
        child: Container(
            width: 15.w,
            child: Column(children: [
              Marquee(
                  autoRepeat: true,
                  child: Text(
                    PlayerUpdate.videoTitle,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w800,
                      fontSize: 10.0.sp,
                      color: Colors.black,
                    ),
                  )),
              Marquee(
                  autoRepeat: true,
                  child: Text(
                    PlayerUpdate.channelName,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w800,
                      fontSize: 9.0.sp,
                      color: Colors.grey,
                    ),
                  )),
            ])));
  }
}
