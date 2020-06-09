import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/music_player.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/queue_generator.dart';
import 'package:musicplayer/widgets/player/player.dart';
import 'package:musicplayer/widgets/extensions/music_metadata.dart';

class Songs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: audioQuery.getSongs(),
        builder: (context, AsyncSnapshot<List<SongInfo>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              List<SongInfo> songs = snapshot.data;
              return Scrollbar(
                child: new ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: songs.length,
                  itemBuilder: (context, i) {
                    return new Column(
                      children: <Widget>[
                        new ListTile(
                          leading: Hero(
                              tag: songs[i].id,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                  child: Image.file(File(songs[i].albumArtwork)))),
                          title: new Text(songs[i].title,
                              maxLines: 1,
                              style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              )),
                          subtitle: new Text(
                            songs[i].artist,
                            maxLines: 1,
                            style: new TextStyle(color: Colors.grey),
                          ),
                          trailing: new Text(
                              new Duration(
                                      milliseconds:
                                          int.parse(songs[i].duration))
                                  .toString()
                                  .split('.')
                                  .first
                                  .substring(3, 7),
                              style: new TextStyle(color: Colors.black54)),
                          onTap: () {
                            PlayQueue queue =
                                QueueGenerate().fromSongs(songs: songs);
                            PlayerWidget.player(context).playWithQueue(queue,
                                metadata: songs[i].toMusic());
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => NowPlaying()));
                          },
                        ),
                      ],
                    );
                  },
                ),
              );
          }
          return Text('end');
        },
      ),
    );
  }
}
