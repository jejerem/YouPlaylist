import 'package:flutter/material.dart';
import 'package:you_play_list/player_page/image_effect.dart';
import 'package:you_play_list/player_page/player_update.dart';

import 'image_song.dart';

class ImagesSection extends StatefulWidget {
  const ImagesSection({Key? key}) : super(key: key);

  @override
  _ImagesSectionState createState() => _ImagesSectionState();
}

class _ImagesSectionState extends State<ImagesSection> {
  late final Stream streamControllerThumbnail;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [ImageSong(), ImageEffect()]));
  }
}
