import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/music_player.dart';
import 'package:musicplayer/util/random.dart';

class QueueGenerate {
  PlayQueue fromSongs({@required List<SongInfo> songs, String title}) {
    int randomInt = Random(10).nextInt(10000);
    String randomString = getRandomString(length: 10);
    String queueTitle = title != null ? title : randomString;
    return PlayQueue(
        queueId: randomInt.toString(),
        queueTitle: queueTitle,
        queue: metadataFromSong(songs: songs));
  }

  List<MusicMetadata> metadataFromSong({@required List<SongInfo> songs}) {
    return songs.map((f) => MusicMetadata(
        mediaId: f.id,
        title: f.title,
        subtitle: f.artist,
        duration: int.parse(f.duration),
        mediaUri: f.filePath,
        iconUri: f.albumArtwork)).toList();
  }
}
