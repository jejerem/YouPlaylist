import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static const String youtube_url = "https://www.youtube.com";
  static const String insta_oce_url = "https://www.instagram.com/massouliero/";

  static const String apkFileUrl =
      "https://drive.google.com/file/d/1d9fDAUdjY5IEfuft29flSInRHdMlcPTI/view";
  static const String apkCheckFileUrl =
      "https://drive.google.com/file/d/1d9fDAUdjY5IEfuft29flSInRHdMlcPTI/view";

  // Asset path of the default image for the player page
  static const AssetImage defaultImagePlayerUrl =
      AssetImage("assets/images/logo_ypl.png");

  static const AssetImage logoApp = AssetImage("assets/images/logo_ypl.png");
  static const AssetImage cover_side_menu =
      AssetImage("assets/images/cover_side_menu.png");

  static TextStyle defaultFont = GoogleFonts.lato(
    fontWeight: FontWeight.w800,
    fontSize: 17.0,
    color: Colors.white,
  );

  static TextStyle linkFont = GoogleFonts.lato(
    fontWeight: FontWeight.w800,
    fontSize: 17.0,
    color: Colors.blue,
  );

  static TextStyle creditFont = GoogleFonts.lato(
    fontWeight: FontWeight.w500,
    fontSize: 17.0,
    color: Colors.white,
  );

  // Javascript functions to modify the behavior of YouTube

  // For linkToProgram function
  static const String linkToProgram = """
    var videos = document.getElementsByTagName('a');
    for (var i=0; i<videos.length; i++){
      
      if (videos[i].getAttribute('href') != null){
        var url = videos[i].getAttribute('href');
        if (!(url.includes('watch'))){
            continue;
          }
        videos[i].setAttribute('rel', url)
        videos[i].setAttribute("onclick", "PlaySong.postMessage(this.getAttribute('rel'))");
        videos[i].removeAttribute('href');
      }
    }
    """;

  // For linkSongsFromPlaylist function
  static const String linkSongsFromPlaylist = """
    var videos = document.getElementsByTagName('a');
    for (var i=0; i<videos.length; i++){
      var url = videos[i].getAttribute('href');
      if (url != null){
        if (url.includes("watch")){
          if (!url.includes("index")){
            url += "&index=1";
          }
          videos[i].setAttribute('rel', url);
          videos[i].setAttribute("onclick", "PlaySongPL.postMessage(this.getAttribute('rel'))");
          videos[i].removeAttribute('href');
        }
      }
    }
    """;
}
