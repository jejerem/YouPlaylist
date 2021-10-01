import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:you_play_list/assets_youtube_player.dart';
import 'package:you_play_list/webview_interactions/link.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' show Video;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../requests_tasks/app_infos.dart';
import '../constantes/constants.dart';

class WebViewYTB extends StatefulWidget {
  WebViewYTB({Key? key}) : super(key: key);

  @override
  _WebViewYTBState createState() => _WebViewYTBState();
}

class _WebViewYTBState extends State<WebViewYTB> with WidgetsBindingObserver {
  AssetsYoutubePlayer assetsYoutubePlayer = AssetsYoutubePlayer();
  WebViewController? _webViewController;
  String? currentUrl;
  String currentPlaylistUrl = "";
  String sameOrPrevPlUrl = "";
  Timer? timer;
  bool activated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        PlayerUpdate.isInApp = true;
        assetsYoutubePlayer.cancelTimerOrActive();

        if (PlayerUpdate.assetsAudioPlayer!.isPlaying.value !=
            PlayerUpdate.isPlaying) {
          PlayerUpdate.isPlaying =
              PlayerUpdate.assetsAudioPlayer!.isPlaying.value;
        }

        break;
      case AppLifecycleState.inactive:
        PlayerUpdate.isInApp = false;
        PlayerUpdate.assetsYoutubePlayer!.cancelTimerOrActive();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  void linkToProgram() async {
    await _webViewController!.evaluateJavascript(Constants.linkToProgram);
  }

  void makeYoutubeDark() async {
    // In development for dark theme.

    await _webViewController!.evaluateJavascript("""
    
      document.styleSheets[3].insertRule(".chip-container {background-color : rgba(255,255,255,0.102);}",document.styleSheets[3].cssRules.length);
      
      document.styleSheets[3].insertRule("ytm-chip-cloud-chip-renderer {background-color : white;}",document.styleSheets[3].cssRules.length);
      document.styleSheets[3].insertRule(".chip-bar-contents {background-color : black;}",document.styleSheets[3].cssRules.length);
      

      document.styleSheets[3].insertRule("body {background-color : #0f0f0f}",document.styleSheets[3].cssRules.length);
      document.styleSheets[3].insertRule(".large-media-item-headline {color : white}",document.styleSheets[3].cssRules.length);
      document.styleSheets[3].insertRule(".ytm-badge-and-byline-item-byline.small-text {color : ghostwhite}",document.styleSheets[3].cssRules.length);
      """);
  }

  void makeYoutubeButtonInvisible() async {
    // We make their bottom bar invisible to replace it with ours.

    await _webViewController!.evaluateJavascript("""
      var youtubeButton = document.getElementsByClassName('mobile-topbar-header-endpoint');
      if (bottomBar.length != 0){
        youtubeButton[0].hidden = true;
      }
      """);
  }

  void makeBottomBarInvisible() async {
    await _webViewController!.evaluateJavascript("""
      var bottomBar = document.getElementsByTagName('ytm-pivot-bar-renderer');
      if (bottomBar.length != 0){
        bottomBar[0].hidden = true;
      }
      """);
  }

  void linkSongsFromPlayList() async {
    await _webViewController!
        .evaluateJavascript(Constants.linkSongsFromPlaylist);
  }

  Future<bool> onWillPop() async {
    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.of(context).pop();
      return false;
    }
    if (await _webViewController!.canGoBack()) {
      _webViewController!.goBack();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    assetsYoutubePlayer.init(context);
    PlayerUpdate.assetsYoutubePlayer = assetsYoutubePlayer;
    PlayerUpdate.assetsAudioPlayer = assetsYoutubePlayer.assetsAudioPlayer;

    var height = MediaQuery.of(context).padding.top;

    return Padding(
        padding: EdgeInsets.only(top: height),
        child: WillPopScope(
            onWillPop: onWillPop,
            child: WebView(
              initialUrl: Constants.youtube_url,
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: Set.from([
                JavascriptChannel(
                    name: 'PlaySong',
                    onMessageReceived: (JavascriptMessage url) async {
                      if (assetsYoutubePlayer.inPlaylist) {
                        assetsYoutubePlayer.inPlaylist = false;

                        if (assetsYoutubePlayer.isShuffled) {
                          assetsYoutubePlayer.isShuffled = false;
                          PlayerUpdate.isShuffled = false;
                        }
                      }

                      if (assetsYoutubePlayer.isLoading) {
                        return;
                      }

                      assetsYoutubePlayer.isLoading = true;

                      var message = url.message;

                      String fullUrl = "${Constants.youtube_url}$message";
                      Video video =
                          await assetsYoutubePlayer.checkAndGetVideo(fullUrl);
                      assetsYoutubePlayer.playSong(video);

                      if (PlayerUpdate.loopMode == LoopMode.none) {
                        PlayerUpdate.switchLoopMode();
                      }
                    }),
                JavascriptChannel(
                    name: 'PlaySongPL',
                    onMessageReceived: (JavascriptMessage url) async {
                      String? currentUrl =
                          await _webViewController!.currentUrl();

                      if (assetsYoutubePlayer.mapPlSongs[currentUrl!] == null) {
                        return;
                      }

                      String fullUrl = Constants.youtube_url + url.message;
                      if (!assetsYoutubePlayer.isLoading) {
                        if (assetsYoutubePlayer
                                .mapPlSongs[currentUrl]!.length ==
                            0) {
                          return;
                        }

                        assetsYoutubePlayer.isLoading = true;
                        Video? videoFound;

                        assetsYoutubePlayer.mapPlSongs[currentUrl]!
                            .forEach((video) {
                          if (video.url == fullUrl.split("&")[0]) {
                            videoFound = video;
                          }
                        });

                        if (videoFound == null) {
                          int indexSongInPL =
                              int.parse(fullUrl.split("=").last) - 1;
                          videoFound = assetsYoutubePlayer
                              .mapPlSongs[currentUrl]![indexSongInPL];
                        }
                        if ((currentPlaylistUrl != sameOrPrevPlUrl) ||
                            assetsYoutubePlayer.listSongsCurrentPlaylist ==
                                []) {
                          if (assetsYoutubePlayer.isShuffled) {
                            PlayerUpdate.isShuffled = false;
                            assetsYoutubePlayer.isShuffled = false;
                          }
                          sameOrPrevPlUrl = currentPlaylistUrl;
                          PlayerUpdate.sameOrPrevPlUrl = sameOrPrevPlUrl;
                          assetsYoutubePlayer.listSongsCurrentPlaylist =
                              assetsYoutubePlayer.mapPlSongs[currentUrl]!;
                        }
                        assetsYoutubePlayer.playSongsFromPlayList(videoFound!);
                        if (PlayerUpdate.loopMode == LoopMode.single) {
                          PlayerUpdate.switchLoopMode();
                        }
                      }
                    }),
                JavascriptChannel(
                    name: 'Place',
                    onMessageReceived: (JavascriptMessage message) async {
                      currentUrl = await _webViewController!.currentUrl();
                      if (currentUrl!.contains("#menu")) {
                        currentUrl = currentUrl!.replaceAll("#menu", "");
                      }
                      if (currentUrl!.contains("playlist?list=")) {
                        assetsYoutubePlayer.inPlaylist = true;
                        if (currentPlaylistUrl != currentUrl) {
                          sameOrPrevPlUrl = currentPlaylistUrl;
                          PlayerUpdate.sameOrPrevPlUrl = sameOrPrevPlUrl;
                          assetsYoutubePlayer
                              .refreshSongsFromCurrentPlaylist(currentUrl!);
                        }

                        currentPlaylistUrl = currentUrl!;
                        linkSongsFromPlayList();
                      } else {
                        linkToProgram();
                      }
                    }),
                JavascriptChannel(
                    name: 'Loop',
                    onMessageReceived: (JavascriptMessage message) async {
                      Link.mutation(_webViewController!);
                    })
              ]),
              navigationDelegate: (NavigationRequest request) async {
                if (request.url.contains("google") ||
                    request.url.contains("youtube") ||
                    request.url.contains("select_site")) {
                  activated = false;
                }
                return NavigationDecision.navigate;
              },
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
                AppInfos.checkVersion(context);
                makeYoutubeButtonInvisible();
              },
              onPageFinished: (url) async {
                PlayerUpdate.webViewController = _webViewController;
                makeBottomBarInvisible();

                if (!activated) {
                  Link.mutation(_webViewController!);
                  activated = true;
                }
              },
            )));
  }
}
