import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../assets_youtube_player.dart';

class PlayerUpdate {
  static AssetsYoutubePlayer? assetsYoutubePlayer;
  static AssetsAudioPlayer? assetsAudioPlayer;

  static WebViewController? webViewController;

  static StreamController<int> streamControllerButtons =
      StreamController<int>.broadcast();

  static StreamController<int> streamControllerPlayerPage =
      StreamController<int>.broadcast();

  static StreamController<int> streamControllerFABPlayer =
      StreamController<int>();

  static late var listStreams;

  static late Stream<int> stream;

  static Duration videoDuration = Duration(minutes: 1);

  static LoopMode loopMode = LoopMode.none;

  static bool isShuffled = false;
  static bool isPlaying = false;
  static bool isStopped = !assetsAudioPlayer!.current.hasValue;

  static String videoTitle = "Press any video";
  static String channelName = "Press any video";
  static String thumbnailUrl = "";
  static String? sameOrPrevPlUrl;

  static bool hasNewFloatingVideo = false;
  static bool hasNewPlayerVideo = false;

  static bool isInApp = true;

  static double buttonOpacity = 1.0;
  static PageController? controller;

  static void initPPStream() {
    streamControllerButtons.onListen = () {};
    stream = streamControllerPlayerPage.stream;
  }

  static void playPreviousVideo() {
    PlayerUpdate.assetsYoutubePlayer!.onPrev();
  }

  static void playNextVideo() {
    if (assetsYoutubePlayer!.inPlaylist) {
      assetsYoutubePlayer!.onFinished(null);
    } else {
      PlayerUpdate.assetsAudioPlayer!.seekBy(Duration(seconds: 10));
    }
  }

  static void switchLoopMode() {
    loopMode = loopMode == LoopMode.none ? LoopMode.single : LoopMode.none;
    assetsAudioPlayer!.setLoopMode(loopMode);
  }

  static void loadSaveImage() {
    /// To load and save thumbnail for PlayerPage's images.

    if (assetsAudioPlayer!.current.valueOrNull != null) {
      PlayerUpdate.thumbnailUrl = assetsAudioPlayer!.getCurrentAudioImage!.path;
    }
  }

  static void loadSaveTitleInfos() {
    /// To load and save title infos for title section.

    String channelName = "", videoTitle = "";

    // We check if a song is currently playing.
    if (assetsAudioPlayer!.current.valueOrNull != null) {
      channelName = assetsAudioPlayer!.getCurrentAudioArtist;
      videoTitle = assetsAudioPlayer!.getCurrentAudioTitle;

      PlayerUpdate.channelName = channelName;
      PlayerUpdate.videoTitle = videoTitle;
    }
  }
}
