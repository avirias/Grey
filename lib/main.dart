import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:musicplayer/database/database_client.dart';
import 'dart:async';
import 'package:musicplayer/musichome.dart';
import 'package:musicplayer/views/HomeShimmer.dart';

void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        errorColor: Colors.transparent,

        fontFamily: "Quicksand"
      ),
      home: MusicHome(),
    );
  }
}
