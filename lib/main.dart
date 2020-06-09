import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/music_player.dart';
import 'package:musicplayer/home_page.dart';
import 'package:musicplayer/util/theme.dart';
import 'package:musicplayer/widgets/player/player.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(new MyApp());
}

@pragma("vm:entry-point")
void playerBackgroundService() {
  runBackgroundService(
    playUriInterceptor: (mediaId, fallbackUrl) async {
      debugPrint("get media play uri : $mediaId , $fallbackUrl");
      return fallbackUrl;
    },
    imageLoadInterceptor: (metadata) async {
      debugPrint(
          "load image for ${metadata.mediaId} , ${metadata.title},uri =  ${metadata.iconUri}");
      final data = await File(metadata.iconUri).readAsBytes();
      return data;
    },
    playQueueInterceptor: PlayQueueInterceptor(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return PlayerWidget(
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: accentColor,
              canvasColor: Colors.transparent,
              errorColor: Colors.transparent,
              fontFamily: "Google Sans"),
          home: MusicHome(),
        ),
      ),
    );
  }
}
