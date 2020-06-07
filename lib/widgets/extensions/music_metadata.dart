
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/music_player.dart';

extension SongMapper on SongInfo {
    MusicMetadata toMusic(){
      return MusicMetadata(
        title: this.title,
        duration: int.parse(this.duration),
        mediaId: this.id,
        iconUri: this.albumArtwork,
        mediaUri: this.filePath,
        subtitle: this.artist
      );
    }
}