import 'dart:async';
import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

dynamic getImage(Song song) {
  return song.albumArt == null
      ? null
      : new File.fromUri(Uri.parse(song.albumArt));
}

Widget avatar(context,File f, String title) {
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
class Repeat {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/repeat.txt');
  }

  Future<int> read() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If we encounter an error, return 0
      return 0;
    }
  }

  Future<File> write(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}