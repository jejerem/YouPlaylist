import 'dart:async';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeData {
  YoutubeData();

  Future<Iterable<AudioOnlyStreamInfo>> getAudio(Video video) async {
    // get video's "audio only" streams.
    YoutubeExplode yt = YoutubeExplode();
    var manifest = await yt.videos.streamsClient.getManifest(video.url);
    var streams = manifest.audioOnly;
    yt.close();
    return streams;
  }

  Future<Video> getVideo(String url) async {
    // get video data
    YoutubeExplode yt = YoutubeExplode();
    var video = await yt.videos.get(url);
    yt.close();
    return video;
  }

  Future<List> getInfos(Video video) async {
    // get video data and audio only stream.
    var audio;
    var streams = await getAudio(video);
    if (streams.length > 0) {
      audio = streams.first;
    } else {
      return [];
    }
    return [audio, video];
  }

  Future<List<Video>> getSongsFromCurrentPlaylist(String? currentUrl) async {
    // Load songs and store them in the mapPlSongs.
    YoutubeExplode yt = YoutubeExplode();

    Stream<Video> videos = yt.playlists.getVideos(currentUrl);
    List<Video> listVideos = await videos.toList();
    yt.close();
    return listVideos;
  }
}
