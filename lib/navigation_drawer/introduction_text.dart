import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:you_play_list/constants/values.dart';

class IntroText extends StatelessWidget {
  String? contentCreated;
  String? creatorName;
  String? instaPseudo;

  IntroText(
      {required String this.contentCreated,
      required String this.creatorName,
      String this.instaPseudo = ""});

  @override
  Widget build(BuildContext context) {
    if (instaPseudo != "") {
      String instaAccountUrl = Constants.instaUrl + instaPseudo!;

      return Container(
          height: 15.h,
          width: 60.w,
          child: Column(children: [
            Text("$contentCreated by $creatorName",
                style: Constants.creditFont),
            Text(
              "Instagram : ",
              style: Constants.creditFont,
            ),
            InkWell(
                onTap: () {
                  launch(instaAccountUrl);
                },
                child: Text(
                  "$instaPseudo",
                  style: Constants.linkFont,
                )),
          ]));
    }

    return Container(
        child: Column(children: [
      Text("$contentCreated by $creatorName", style: Constants.creditFont)
    ]));
  }
}
