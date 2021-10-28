import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:you_play_list/constants/values.dart';
import 'package:you_play_list/navigation_drawer/introduction_text.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({Key? key}) : super(key: key);

  @override
  _CreditsPageState createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listLogos = [
      Container(
          height: 25.h,
          width: 32.h,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            Container(
                height: 25.h,
                width: 25.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: Constants.logoApp))),
            Container(
                height: 25.h,
                width: 30.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: Constants.cover_side_menu)))
          ])),
      null,
      null
    ];
    var listText = [
      IntroText(
          contentCreated: "Designs made",
          creatorName: "Océane Massoulier",
          instaPseudo: "massouliero"),
      IntroText(
          contentCreated: "YouPlaylist developed",
          creatorName: "Jérémy Rozier",
          instaPseudo: "jeremyrozier"),
      IntroText(contentCreated: "YouTube Website", creatorName: "Google")
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Credits", style: Constants.defaultFont),
      ),
      body: ListView.builder(
        itemCount: listText.length,
        itemBuilder: (context, i) {
          if (listLogos[i] != null) {
            return Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Column(
                  children: [listText[i], listLogos[i]!],
                ));
          } else {
            return Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [listText[i]],
                ));
          }
        },
      ),
    );
  }
}
