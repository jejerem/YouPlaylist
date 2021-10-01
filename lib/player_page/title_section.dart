import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:you_play_list/player_page/player_update.dart';

class TitleSection extends StatefulWidget {
  TitleSection({Key? key, String? channelName}) : super(key: key);
  String? channelName;
  @override
  _TitleSectionState createState() => _TitleSectionState();
}

class _TitleSectionState extends State<TitleSection> {
  @override
  Widget build(BuildContext context) {
    PlayerUpdate.loadSaveTitleInfos();
    return Container(
      height: 200,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            PlayerUpdate.channelName,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w800,
              fontSize: 17.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
