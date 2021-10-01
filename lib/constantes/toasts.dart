import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Toasts {
  const Toasts();

  static late BuildContext context;

  static void init(BuildContext ctx) {
    context = ctx;
  }

  static void toastErrorVideo(Video video, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${video.title} $message",
            style: TextStyle(color: Colors.red)),
        duration: Duration(milliseconds: 1500)));
  }

  static void toastPrivatePl() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              "You are in a private playlist. Please make it unlisted or public",
              style: TextStyle(color: Colors.red)),
          duration: Duration(milliseconds: 1500)),
    );
  }
}
