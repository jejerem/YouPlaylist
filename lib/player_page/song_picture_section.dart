import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:you_play_list/player_page/player_update.dart';

class SongPictureSection extends StatefulWidget {
  SongPictureSection({Key? key}) : super(key: key);

  @override
  _SongPictureSectionState createState() => _SongPictureSectionState();
}

class _SongPictureSectionState extends State<SongPictureSection> {
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 23.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
        ),
      ),
    );
  }
}
