import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/lastplay.dart';

class Songs extends StatefulWidget {
  final DatabaseClient db;

  Songs(this.db);

  @override
  State<StatefulWidget> createState() {
    return new SongsState();
  }
}

class SongsState extends State<Songs> {


  dynamic getImage(Song song) {
    return song.albumArt == null
        ? null
        : new File.fromUri(Uri.parse(song.albumArt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: widget.db.fetchSongs(),
        builder: (context,AsyncSnapshot<List<Song>> snapshot){
          switch(snapshot.connectionState){

            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              List<Song> songs = snapshot.data;
              return Scrollbar(
                child: new ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: songs.length,
                  itemBuilder: (context, i) => new Column(
                    children: <Widget>[
                      new ListTile(
                        leading: Hero(
                            tag: songs[i].id,
                            child: getImage(songs[i]) != null
                            ? Image.file(
                              getImage(songs[i]),
                              width: 55.0,
                              height: 55.0,
                              // TODO :  Check here
                            ) : Icon(Icons.music_note)
                        ),
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
                            new Duration(milliseconds: songs[i].duration)
                                .toString()
                                .split('.')
                                .first
                                .substring(3, 7),
                            style: new TextStyle(
                                fontSize: 12.0, color: Colors.black54)),
                        onTap: () {
                          MyQueue.songs = songs;
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new NowPlaying(
                                  widget.db, MyQueue.songs, i, 0)));
                        },
                      ),
                    ],
                  ),
                ),
              );
          }
          return Text('end');
        },
      ),
    );
  }
}
