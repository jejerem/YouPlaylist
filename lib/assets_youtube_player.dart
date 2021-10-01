import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:you_play_list/player_page/player_update.dart';
import 'package:you_play_list/requests_tasks/youtube_data.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart'
    show AudioOnlyStreamInfo, Video;

import 'constantes/toasts.dart';

class AssetsYoutubePlayer {
  AssetsYoutubePlayer() {
    youtubeData = YoutubeData();
  }

  Timer? timerEnd;

  // Is loading to lock when a song is loading
  bool isLoading = false;

  // True when the app is playing a playlist
  bool inPlaylist = false;

  // True  if the video is in suffled mode (random) in playlists
  bool isShuffled = false;

  // Music player object
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  // Video object of the current video (song played)
  Video? currentVideo;

  // List containing the songs of the current Playlist
  List<Video> listSongsCurrentPlaylist = [];

  // List containing the songs already listened to of the current Playlist
  List<Video> listSongsListenedCurrentPlaylist = [];

  // List containing the songs shuffled of the current Playlist
  List<Video> listSongsShuffledCurrentPlaylist = [];

  /// List useful for "scroll feature" to play songs of a playlist
  /// in the menu of another one
  List<Video> listSongsTransitionPl = [];

  /// list which stocks songs removed when we can't play them
  /// (error handled in playSong)
  List listSongsRemoved = [];

  // map which stores infos of songs with their url {'songUrl' : [audio, video]}
  Map<String, List> mapSongInfos = {};
  // map which stores songs with their playlist {'playlistUrl' : [songs]}
  Map<String, List<Video>> mapPlSongs = {};

  late YoutubeData youtubeData;

  void init(BuildContext context) {
    // Object which displays toasts
    Toasts.init(context);
  }

  Future<List> checkAndGetInfos(Video video) async {
    /// get audio and video infos of the video and check the result

    if (mapSongInfos.containsKey(video.url)) {
      if (mapSongInfos[video.url]!.length == 2) {
        return mapSongInfos[video.url]!;
      }
    }

    var resultInfos = await youtubeData.getInfos(video);
    if (resultInfos.length == 0) {
      Toasts.toastErrorVideo(video, "can't be loaded");

      if (inPlaylist) {
        if (currentVideo != null) {
          if (indexOfSongPl(video, listSongsCurrentPlaylist) <
              indexOfSongPl(currentVideo!, listSongsCurrentPlaylist)) {
            currentVideo = listSongsCurrentPlaylist[
                (indexOfSongPl(video, listSongsCurrentPlaylist) - 1) %
                    listSongsCurrentPlaylist.length];
          } else {
            currentVideo = listSongsCurrentPlaylist[
                (indexOfSongPl(video, listSongsCurrentPlaylist) + 1) %
                    listSongsCurrentPlaylist.length];
          }
        }
        listSongsCurrentPlaylist.remove(video);
        listSongsRemoved.add(video);
      }

      return [];
    } else {
      return resultInfos;
    }
  }

  int indexOfSongPl(Video video, List listPl) {
    /// Instead of comparing videos objects we compare their url cuz
    /// some metadatas are loaded only with the method yt.videos.get(id).

    int c = 0;
    for (Video videoPl in listPl) {
      if (videoPl.url == video.url) {
        break;
      }
      c++;
    }
    return c;
  }

  bool isContaining(List listPl, Video video) {
    /// Return true if listPl contains the video object by comparing urls.

    for (Video videoPl in listPl) {
      if (videoPl.url == video.url) {
        return true;
      }
    }
    return false;
  }

  bool isContainingAll(List listPl, List<Video> listVideos) {
    for (Video video in listVideos) {
      if (!isContaining(listPl, video)) {
        return false;
      }
    }

    return true;
  }

  Future<Video> checkAndGetVideo(String url) async {
    /// Check if the video object is stored and we return it
    /// if the map doesn't contain it, we make and return it

    if (mapSongInfos.containsKey(url)) {
      return mapSongInfos[url]![1];
    }

    return await youtubeData.getVideo(url);
  }

  List getAudioFromMap(Video nextVideo) {
    if (mapSongInfos[nextVideo.url]!.length == 0) {
      return [];
    }
    var audio = mapSongInfos[nextVideo.url]![0];
    return [audio];
  }

  Video getNextVideo() {
    // Returns the next video object in a playlist

    Video nextVideo;
    int currentIndexSong =
        indexOfSongPl(currentVideo!, listSongsCurrentPlaylist);
    int nextIndexSong = currentIndexSong + 1;

    nextVideo = listSongsCurrentPlaylist[
        nextIndexSong % listSongsCurrentPlaylist.length];

    return nextVideo;
  }

  Video getPrevVideo() {
    // Returns the previous video object in a playlist

    Video prevVideo;
    int currentIndexSong =
        indexOfSongPl(currentVideo!, listSongsCurrentPlaylist);
    int prevIndexSong;
    prevIndexSong = currentIndexSong - 1;

    prevVideo = listSongsCurrentPlaylist[
        prevIndexSong % listSongsCurrentPlaylist.length];

    return prevVideo;
  }

  void refreshSongsFromCurrentPlaylist(String currentUrl) async {
    List<Video> listVideos =
        await youtubeData.getSongsFromCurrentPlaylist(currentUrl);
    if (listVideos.length != 0) {
      mapPlSongs[currentUrl] = listVideos;
    } else {
      Toasts.toastPrivatePl();
      mapPlSongs[currentUrl] = [];
    }
  }

  void openSong(AudioOnlyStreamInfo audio, Video video) async {
    // open a player and the song of the url stored in the object audio
    try {
      await assetsAudioPlayer.open(
          Audio.network(
            "${audio.url}",
            metas: Metas(
                title: video.title,
                artist: video.author,
                image: MetasImage.network(video.thumbnails.highResUrl)),
          ),
          showNotification: true,
          headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
          loopMode: PlayerUpdate.loopMode,
          notificationSettings: NotificationSettings(
              customPlayPauseAction: (AssetsAudioPlayer assetsAudioPlayer) {
            if (PlayerUpdate.isStopped) {
              PlayerUpdate.isStopped = false;
            }
            PlayerUpdate.isPlaying = PlayerUpdate.isPlaying ? false : true;
            assetsAudioPlayer.playOrPause();
            if (inPlaylist) {
              cancelTimerOrActive();
            }
            PlayerUpdate.streamControllerButtons.add(1);
          }, customNextAction: (AssetsAudioPlayer assetsAudioPlayer) {
            if (inPlaylist) {
              onFinished(true);
            } else {
              // User is in research
              assetsAudioPlayer.seekBy(Duration(seconds: 10));
            }
          }, customPrevAction: (AssetsAudioPlayer assetsAudioPlayer) {
            if (inPlaylist) {
              onPrev();
            } else {
              // User is in research
              assetsAudioPlayer.seekBy(Duration(seconds: -10));
            }
          }, customStopAction: (AssetsAudioPlayer assetsAudioPlayer) {
            assetsAudioPlayer.stop();

            PlayerUpdate.isStopped = true;
            PlayerUpdate.isPlaying = false;
            PlayerUpdate.streamControllerButtons.add(1);
          }));
    } catch (t) {
      print("Stream unreachable");
    }
    PlayerUpdate.isPlaying = true;
    PlayerUpdate.isStopped = false;

    PlayerUpdate.streamControllerFABPlayer.add(1);
    PlayerUpdate.streamControllerPlayerPage.add(1);
  }

  void cancelTimerOrActive() {
    if (PlayerUpdate.isInApp) {
      if (timerEnd != null) {
        timerEnd!.cancel();
      }
      return;
    }

    if (!PlayerUpdate.isPlaying || !inPlaylist) {
      if (timerEnd != null) {
        timerEnd!.cancel();
      }
    } else {
      if (timerEnd != null) {
        timerEnd!.cancel();
      }
      timerEnd = Timer.periodic(
          Duration(milliseconds: 300), (Timer t) => checkFinished());
    }
    PlayerUpdate.streamControllerButtons.add(1);
  }

  void playSong(Video video) async {
    // Play a song

    if (video.isLive) {
      Toasts.toastErrorVideo(video, "is a live.");
      isLoading = false;
      return;
    }
    if (mapSongInfos.containsKey(video.url) &&
        !isContaining(listSongsRemoved, video)) {
      if (mapSongInfos[video.url]!.length == 2) {
        if (inPlaylist) {
          if (!isContaining(listSongsListenedCurrentPlaylist, video)) {
            listSongsListenedCurrentPlaylist.add(video);
          }
        }
        var audio;
        audio = mapSongInfos[video.url]![0];
        openSong(audio, video);
        isLoading = false;

        return;
      }
    }
    var infos = await checkAndGetInfos(video);

    if (infos.length == 0) {
      if (inPlaylist) {
        // Current video is the next one.
        playSong(currentVideo!);
      }
      isLoading = false;
      return;
    }

    if (inPlaylist) {
      if (!isContaining(listSongsListenedCurrentPlaylist, video)) {
        listSongsListenedCurrentPlaylist.add(video);
      }
    } else {
      currentVideo = video;
    }

    var audio = infos[0];
    mapSongInfos[video.url] = [audio, video];
    openSong(audio, video);
    isLoading = false;
  }

  void playSongsFromPlayList(Video video) async {
    playSong(video);
    currentVideo = video;
    var nextVideo = getNextVideo();
    loadNextVideo(nextVideo);
    isLoading = false;
  }

  void onPrev() {
    // Function called when the previous button is triggered.

    if (inPlaylist) {
      if (isContainingAll(
          listSongsListenedCurrentPlaylist, listSongsCurrentPlaylist)) {
        // Necessary to shuffle it again
        isShuffled = false;
        onShuffle();
      }
      currentVideo = getPrevVideo();
      playSong(currentVideo!);
    } else {
      assetsAudioPlayer.seekBy(Duration(seconds: -10));
    }
  }

  void onShuffle() async {
    // Function called when the shuffle button is triggered.
    if (!inPlaylist) {
      return;
    }

    // We clear the content of the list of the song already listened to.
    listSongsListenedCurrentPlaylist.clear();

    isShuffled = isShuffled ? false : true;
    PlayerUpdate.isShuffled = isShuffled;

    String? url;

    url = PlayerUpdate.sameOrPrevPlUrl == ""
        ? await PlayerUpdate.webViewController!.currentUrl()
        : PlayerUpdate.sameOrPrevPlUrl!;

    if (PlayerUpdate.isShuffled) {
      listSongsCurrentPlaylist = mapPlSongs[url]!.toList()..shuffle();
    } else {
      listSongsCurrentPlaylist = mapPlSongs[url]!;
    }

    if (!assetsAudioPlayer.isPlaying.value) {
      if (assetsAudioPlayer.current.hasValue) {
        if (isContaining(listSongsCurrentPlaylist, currentVideo!)) {
          listSongsListenedCurrentPlaylist.add(currentVideo!);
          return;
        }
      }
      playSongsFromPlayList(listSongsCurrentPlaylist.first);
    } else if (!isContaining(listSongsCurrentPlaylist, currentVideo!)) {
      playSongsFromPlayList(listSongsCurrentPlaylist.first);
    }
    listSongsListenedCurrentPlaylist.add(currentVideo!);
    loadNextVideo(getNextVideo());
  }

  void loadNextVideo(nextVideo) async {
    // Load the video we want in a playlist.

    int currentIndexSong = indexOfSongPl(nextVideo, listSongsCurrentPlaylist);
    if (!mapSongInfos.containsKey(nextVideo.url)) {
      isLoading = true;
      var index;
      List resultInfos = await checkAndGetInfos(nextVideo);
      int i = 1;
      mapSongInfos[nextVideo.url] = resultInfos;
      while (resultInfos == []) {
        index = (currentIndexSong + i) % listSongsCurrentPlaylist.length;
        if (mapPlSongs[listSongsCurrentPlaylist[index].url] != null) {
          if (mapPlSongs[listSongsCurrentPlaylist[index].url]!.length != 0) {
            break;
          }
        }
        resultInfos = await checkAndGetInfos(listSongsCurrentPlaylist[index]);
        mapSongInfos[listSongsCurrentPlaylist[index].url] = resultInfos;
        i++;
      }
    }
    isLoading = false;
  }

  void checkFinished() {
    if (PlayerUpdate.assetsAudioPlayer!.current.valueOrNull != null &&
        PlayerUpdate.assetsYoutubePlayer!.inPlaylist) {
      double totalDuration = PlayerUpdate
          .assetsAudioPlayer!.current.value!.audio.duration.inSeconds
          .toDouble();

      if (totalDuration * 99 / 100 <=
          assetsAudioPlayer.currentPosition.value.inSeconds.toDouble()) {
        onFinished(false);
      }
    }
  }

  void onFinished(bool? isNextButton) async {
    // Run when the current song of a playlist just finished to play.
    if (!inPlaylist) {
      if (PlayerUpdate.loopMode == LoopMode.none) {
        PlayerUpdate.isPlaying = false;
        PlayerUpdate.streamControllerButtons.add(1);
        return;
      } else if (PlayerUpdate.loopMode == LoopMode.single) {
        return;
      }
    } else {
      if (PlayerUpdate.loopMode == LoopMode.single) {
        if (isNextButton != null) {
          if (!isNextButton) {
            return;
          }
        }
      }
    }

    if (isContainingAll(
        listSongsListenedCurrentPlaylist, listSongsCurrentPlaylist)) {
      // Necessary to shuffle it again
      isShuffled = false;
      onShuffle();
    }

    isLoading = true;
    Video nextVideo;
    Video nextSecondVideo;
    nextVideo = getNextVideo();
    currentVideo = nextVideo;
    nextSecondVideo = getNextVideo();
    playSong(nextVideo);
    loadNextVideo(nextSecondVideo);
    isLoading = false;
  }
}
