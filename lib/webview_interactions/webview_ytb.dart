import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/scheduler.dart';
import 'package:you_play_list/assets_youtube_player.dart';
import 'package:you_play_list/navigation_drawer/settings_update.dart';
import 'package:you_play_list/webview_interactions/link.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' show Video;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../requests_tasks/app_infos.dart';
import 'package:you_play_list/constants/values.dart';

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

  void makeMenuButton() async {
    await _webViewController!.evaluateJavascript("""
    
     """);
  }

  void makeYoutubeDark() async {
    // In development for dark theme.

    await _webViewController!.evaluateJavascript("""
      // html tag.
      document.styleSheets[3].insertRule("html {background-color : #181818;}",document.styleSheets[3].cssRules.length);
      // Main menu title.
      document.styleSheets[3].insertRule(".large-media-item-headline {color : white;}",document.styleSheets[3].cssRules.length);
      // Main menu small text.
      document.styleSheets[3].insertRule(".ytm-badge-and-byline-item-byline.small-text {color : ghostwhite;}",document.styleSheets[3].cssRules.length);

      // Main menu chip containers.
      document.styleSheets[3].insertRule("[chip-style=STYLE_DEFAULT] .chip-container, [chip-style=STYLE_HOME_FILTER] .chip-container, [chip-style=STYLE_REFRESH_TO_NOVEL_CHIP] .chip-container {background-color: hsla(0,0%,100%,0.1); color: #fff;}",document.styleSheets[3].cssRules.length);
      // Main menu selected chip container.
      document.styleSheets[3].insertRule("[chip-style=STYLE_DEFAULT].selected .chip-container, [chip-style=STYLE_HOME_FILTER].selected .chip-container {background-color : #fff;color:#030303;}",document.styleSheets[3].cssRules.length);
      // Main menu chip bar.
      document.styleSheets[3].insertRule(".chip-bar {background-color : #212121;}",document.styleSheets[3].cssRules.length);

      //Video recommended.
      document.styleSheets[3].insertRule(".large-media-item-endorsement-container {background-color : #0f0f0f;color: #aaa}",document.styleSheets[3].cssRules.length);
      
      // Trending top bar
      
      document.styleSheets[3].insertRule("ytm-destination-shelf-renderer {background-color : #181818;}",document.styleSheets[3].cssRules.length);
      document.styleSheets[3].insertRule("ytm-destination-button-renderer {background-color : #212121;}",document.styleSheets[3].cssRules.length);
      document.styleSheets[3].insertRule(".destination-button-label {color: #fff;}",document.styleSheets[3].cssRules.length);

      document.styleSheets[3].insertRule(".ytm-item-section-header-title {color: #fff;}",document.styleSheets[3].cssRules.length);
      document.styleSheets[3].insertRule("h1, h2, h3, h4 {color: #fff;}",document.styleSheets[3].cssRules.length);
      document.styleSheets[3].insertRule(".subhead {color: ghostwhite;}",document.styleSheets[3].cssRules.length);
      document.styleSheets[3].insertRule(".ytm-item-section-renderer {color: ghostwhite; border-bottom:1px solid hsla(0,0%,100%,0.1)}",document.styleSheets[3].cssRules.length);
      document.styleSheets[3].insertRule("c3-icon {color: #fff;}",document.styleSheets[3].cssRules.length);

      // Subscriptions.
  
      document.styleSheets[3].insertRule("ytm-channel-list-sub-menu-renderer {background-color: #0f0f0f;}",document.styleSheets[3].cssRules.length);
      // List subscribed channels
      document.styleSheets[3].insertRule(".channel-list-item-title {color: #fff;}",document.styleSheets[3].cssRules.length);


      // Channels.

      // No videos messages
      document.styleSheets[3].insertRule(".ytm-message-text {color: #fff;}",document.styleSheets[3].cssRules.length);

      // Header.
      document.styleSheets[3].insertRule("ytm-c4-tabbed-header-renderer {background-color: #212121;}",document.styleSheets[3].cssRules.length);

      //Subscription button.
      document.styleSheets[3].insertRule(".button-renderer-text {color: #aaa;}",document.styleSheets[3].cssRules.length);
      // Nb subscribers
      document.styleSheets[3].insertRule(".secondary-text {color: #aaa;}",document.styleSheets[3].cssRules.length);

      // Tabs.
      document.styleSheets[3].insertRule(".scbrr-tabs[is-channel=true] {background-color: #212121; color: #fff;}",document.styleSheets[3].cssRules.length);
      
      // Selected tab.
      document.styleSheets[3].insertRule(".scbrr-tabs[is-channel=true] .scbrr-tab[aria-selected=true]{color: #fff;}",document.styleSheets[3].cssRules.length);
      document.styleSheets[3].insertRule(".scbrr-tab[aria-selected=true]{color: #fff;border-bottom: 2px solid #aaa;}",document.styleSheets[3].cssRules.length);

      // Filters
      document.styleSheets[3].insertRule("ytm-select {background-color: #212121;color: #fff;border:1px solid hsla(0,0%,100%,0.1)}",document.styleSheets[3].cssRules.length);

      //Library.
      
      document.styleSheets[3].insertRule(".compact-link-metadata {color: #fff}",document.styleSheets[3].cssRules.length);

      // Playlists.

      // Header.
      document.styleSheets[3].insertRule(".playlist-header {background-color: black;}",document.styleSheets[3].cssRules.length);
      // Author's name.
      document.styleSheets[3].insertRule("a.playlist-channel-link {color: #fff}",document.styleSheets[3].cssRules.length);
      //Stats.
      document.styleSheets[3].insertRule(".playlist-header-stats {color: #fff}",document.styleSheets[3].cssRules.length);
      
      // Account menu.
      document.styleSheets[3].insertRule(".menu-content {background-color: #181818; color: #fff}",document.styleSheets[3].cssRules.length);

      // Home with no videos.
      document.styleSheets[3].insertRule(".promo-title {color: #fff}",document.styleSheets[3].cssRules.length);
      document.styleSheets[3].insertRule("..promo-subtitle {color: #aaa}",document.styleSheets[3].cssRules.length);
      """);
  }

  void makeYoutubeButtonInvisible() async {
    await _webViewController!.evaluateJavascript("""
      var youtubeButton = document.getElementsByClassName('mobile-topbar-header-endpoint');
      if (bottomBar.length != 0){
        youtubeButton[0].hidden = true;
      }
      """);
  }

  void makeBottomBarInvisible() async {
    // We make their bottom bar invisible to replace it with ours.

    await _webViewController!.evaluateJavascript("""
      var bottomBar = document.getElementsByTagName('ytm-pivot-bar-renderer');
      if (bottomBar.length != 0){
        bottomBar[0].hidden = true;
      }
      """);
  }

  void removeTopBar() async {
    /// We hide their top bar and we remove the padding with the top
    /// to make the implementation of our top bar seems natural.
    await _webViewController!.evaluateJavascript("""
    topBarElements = document.getElementsByTagName('ytm-mobile-topbar-renderer');

    if (topBarElements.length > 0){
      topBarElements[0].hidden = true;
    }

    document.styleSheets[3].insertRule("ytm-app.sticky-player {padding-top : 0px;}", 
    document.styleSheets[3].cssRules.length);

    document.styleSheets[3].insertRule(".rich-grid-sticky-header ytm-feed-filter-chip-bar-renderer {top : 0px;}",
    document.styleSheets[3].cssRules.length);
    
    document.styleSheets[3].insertRule(".rich-grid-sticky-header ytm-feed-filter-chip-bar-renderer.filter-chip-bar-in {top : 0px;}", 
    document.styleSheets[3].cssRules.length);
    
    
    """);
  }

  void selectMusicSection() async {
    await _webViewController!.evaluateJavascript("""
    chips = document.getElementsByClassName('typography-title-1 chip-text')
    for (let i=0; i<videos.length;i++){
      if (chips[i].innerText == "Musique"){
          chips[i].click();
      }
    }""");
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
      return false;
    }

    if (currentUrl != null) {
      if (currentUrl!.contains("google.com")) {
        _webViewController!.loadUrl(Constants.youtube_url);
      }
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
                activated = false;
                PlayerUpdate.webViewController = _webViewController;
                makeBottomBarInvisible();
                removeTopBar();
                var brightness =
                    SchedulerBinding.instance!.window.platformBrightness;

                if (SettingsUpdate.currentTheme == ThemeMode.dark ||
                    SettingsUpdate.currentTheme == ThemeMode.system &&
                        brightness == Brightness.dark) {
                  makeYoutubeDark();
                }

                if (!activated) {
                  Link.mutation(_webViewController!);
                  activated = true;
                }
              },
            )));
  }
}
