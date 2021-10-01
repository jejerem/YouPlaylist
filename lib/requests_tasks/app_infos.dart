import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class AppInfos {
  static void checkVersion(BuildContext context) async {
    /// Check if the version downloaded matches with the official version
    /// of the app on the drive.
    /// If it doesn't, it shows an AlertDialog in which there are two choices:
    /// Download now : redirect towards the drive's apk file.
    /// Later : Close the AlertDialog without doing anything else.

    var url = Uri.parse(Constants.apkCheckFileUrl);
    http.Response response = await http.get(url);

    String data = "";
    try {
      if (response.statusCode == 200) {
        data = response.body;
      } else {
        print("failed");
        return;
      }
    } catch (e) {
      print("failed");
      return;
    }
    // Regex to identify the official version number of the app.
    RegExp regExp = new RegExp(
      r"\d\.\d\.\d",
      caseSensitive: false,
      multiLine: false,
    );

    String? officialVersion = regExp.stringMatch(data);

    if (officialVersion == null) {
      print("Problem in the website");
      return;
    } else {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      if (currentVersion != officialVersion) {
        showDialog(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                // To display the title it is optional.
                title: Text("New version available"),

                // Message which will be pop up on the screen.
                content: Text(
                    "Please download the latest version YouPlaylist $officialVersion"),
                // Action widget which will provide the user to acknowledge the choice.
                actions: [
                  TextButton(
                      child: Text("Download now"),
                      onPressed: () async {
                        // It makes the user download it automatically.
                        await launch(
                          Constants.apkFileUrl,
                        );
                        Navigator.of(context).pop();
                      }),
                  TextButton(
                    child: Text('Later'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    }
  }
}
