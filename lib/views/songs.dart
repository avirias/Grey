import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/model/queue.dart';

class Songs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SongsState();
  }
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
              return CircularProgressIndicator();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              List<SongInfo> songs = snapshot.data;
              return Scrollbar(
                child: new ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: songs.length,
                  itemBuilder: (context, i) {
                    print(songs[i].albumArtwork);
                    return new Column(
                      children: <Widget>[
                        new ListTile(
                          leading: Hero(
                              tag: songs[i].id,
                              //TODO:
                              child: Icon(Icons.music_note)),
                          title: new Text(songs[i].title,
                              maxLines: 1,
                              style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              )),
                          subtitle: new Text(
                            songs[i].artist,
                            maxLines: 1,
                            style: new TextStyle(
                                fontSize: 12.0, color: Colors.grey),
                          ),
                          trailing: new Text(
                              new Duration(
                                      milliseconds:
                                          int.parse(songs[i].duration))
                                  .toString()
                                  .split('.')
                                  .first
                                  .substring(3, 7),
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black54)),
                          onTap: () {
                            MyQueue.songs = songs;
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) =>
                                    new NowPlaying(MyQueue.songs, i, 0)));
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
