import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:sizer/sizer.dart';
import '../constants.dart';
import 'song_picture_section.dart';

class ImageSong extends StatefulWidget {
  ImageSong({Key? key}) : super(key: key);
  @override
  _ImageSongState createState() => _ImageSongState();
}

class _ImageSongState extends State<ImageSong> {
  @override
  Widget build(BuildContext context) {
    PlayerUpdate.loadSaveImage();
    return Container(
      height: 30.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: PlayerUpdate.thumbnailUrl == ""
              ? Constants.defaultImagePlayerUrl as ImageProvider
              : NetworkImage(PlayerUpdate.thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(children: [
        SongPictureSection(),
      ]),
    );
  }
}
