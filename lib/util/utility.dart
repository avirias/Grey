import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';

dynamic getImage(Song song) {
  return song.albumArt == null
      ? null
      : new File.fromUri(Uri.parse(song.albumArt));
}

Widget avatar(File f, String title) {
  return new Material(
    borderRadius: new BorderRadius.circular(30.0),
    elevation: 2.0,
    child: f != null
        ? new CircleAvatar(
      backgroundImage: new FileImage(f,
      ),
    )
        : new CircleAvatar(
      child: new Text(title[0].toUpperCase()),
    ),
  );
}