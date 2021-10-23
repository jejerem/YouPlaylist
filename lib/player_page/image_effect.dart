import 'package:flutter/material.dart';
import 'package:you_play_list/constants/values.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:sizer/sizer.dart';

class ImageEffect extends StatefulWidget {
  const ImageEffect({Key? key}) : super(key: key);

  @override
  _ImageEffectState createState() => _ImageEffectState();
}

class _ImageEffectState extends State<ImageEffect> {
  @override
  Widget build(BuildContext context) {
    PlayerUpdate.loadSaveImage();
    return Container(
        height: 35.h,
        padding: EdgeInsets.only(left: 10.w),
        child: Stack(
          children: [
            Positioned(
              top: 5.h,
              left: 2.h,
              child: Container(
                height: 35.h,
                width: 81.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 1 / 100.h,
              child: Container(
                height: 33.h,
                width: 80.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: PlayerUpdate.thumbnailUrl == ""
                        ? Constants.defaultImagePlayerUrl as ImageProvider
                        : NetworkImage(PlayerUpdate.thumbnailUrl),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.blue.withOpacity(1), BlendMode.modulate),
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
