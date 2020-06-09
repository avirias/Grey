import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class GetImage {
  static FlutterAudioQuery audioQuery = FlutterAudioQuery();

  static Image byAlbum(
      {@required AlbumInfo album,
      @required BoxFit fit,
      double height,
      double width}) {
    return album.albumArt != null
        ? Image.file(
            File('${album.albumArt}'),
            fit: fit,
            width: width,
            height: height,
          )
        : Image.asset(
            "images/back.jpg",
            fit: fit,
            height: height,
            width: width,
          );
  }

  static Future<Image> bySong({@required SongInfo songInfo}) async {
    List<AlbumInfo> albums =
        await audioQuery.getAlbumsById(ids: [songInfo.albumId]);
    return byAlbum(album: albums.elementAt(0),fit: BoxFit.cover);
  }

  static Widget byAlbumAllSongs({@required AlbumInfo album}) {
    return album.albumArt != null
        ? Image.file(File(album.albumArt), fit: BoxFit.fitHeight)
        : Icon(Icons.music_note);
  }
}
