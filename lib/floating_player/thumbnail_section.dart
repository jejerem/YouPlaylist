import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:you_play_list/constants/values.dart';
import 'package:you_play_list/player_page/player_update.dart';

class ThumbnailSection extends StatefulWidget {
  const ThumbnailSection({Key? key}) : super(key: key);
  @override
  _ThumbnailSectionState createState() => _ThumbnailSectionState();
}

class _ThumbnailSectionState extends State<ThumbnailSection> {
  late final Stream streamControllerThumbnail;

  @override
  Widget build(BuildContext context) {
    PlayerUpdate.loadSaveImage();
    return Padding(
        padding: EdgeInsets.only(right: 2.h, left: 1.h),
        child: Container(
          height: 6.h,
          width: 6.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: PlayerUpdate.thumbnailUrl != ""
                  ? NetworkImage(PlayerUpdate.thumbnailUrl)
                  : Constants.logoApp as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
