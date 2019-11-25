import 'dart:async';
import 'dart:math';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/list_songs.dart';

class Playlist extends StatefulWidget {
  final DatabaseClient db;
  Playlist(this.db);

  @override
  State<StatefulWidget> createState() {
    return new _StatePlaylist();
  }
}

class _StatePlaylist extends State<Playlist> {
  var mode;
  List<Song> songs;
  var selected;
  String atFirst,atSecond,atThir;
  String nu = "null";
  Orientation orientation;
  @override
  void initState() {
    super.initState();
    _lengthFind();
    setState(() {
    });
    mode = 1;
    selected = 1;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _lengthFind() async {
    var random = Random();
    songs = await widget.db.fetchRecentSong();
    setState(() {
      atFirst = songs[random.nextInt(songs.length-1)].artist;
    });
    songs = await widget.db.fetchTopSong();
    setState(() {
      atSecond = songs[random.nextInt(songs.length-1)].artist;
    });
    songs = await widget.db.fetchFavSong();
    String atThird = "No Songs in favorites";
    setState(() {
      atThir = songs.length != 0
          ? "Includes ${songs[random.nextInt(songs.length-1)].artist.toString()} and more"
          : atThird;
    });

  }

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return new Container(
      child: orientation == Orientation.portrait ? portrait() : landscape(),
    );
  }

  Widget portrait() {
    return new ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        new ListTile(
          leading: new Icon(
            Icons.history,
            size: 28.0,
          ),
          title: new Text(
            "Recently played",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          ),
          subtitle: new Text(
            "Includes ${atFirst!=null?atFirst:nu} and more",
            maxLines: 1,
          ),
          onTap: () {
            Navigator.of(context)
                .push(new CupertinoPageRoute(builder: (context) {
              return new ListSongs(widget.db, 1, orientation);
            }));
          },
        ),
        new ListTile(
          leading: new Icon(
            Icons.insert_chart,
            size: 28.0,
          ),
          title: new Text(
            "Top tracks",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          ),
          subtitle: new Text(
            "Includes ${atSecond!=null?atSecond:nu} and more",
            maxLines: 1,
          ),
          onTap: () {
            Navigator.of(context)
                .push(new CupertinoPageRoute(builder: (context) {
              return new ListSongs(widget.db, 2, orientation);
            }));
          },
        ),
        new ListTile(
          leading: new Icon(
            Icons.favorite,
            size: 28.0,
          ),
          title: new Text(
            "Favourites",
            style: TextStyle(
                fontSize: 20.0,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500),
          ),
          subtitle: new Text(
            atThir!=null?atThir:nu,
            maxLines: 1,
          ),
          onTap: () {
            Navigator.of(context)
                .push(new CupertinoPageRoute(builder: (context) {
              return new ListSongs(widget.db, 3, orientation);
            }));
          },
        ),
      ],
    );
  }

  Widget landscape() {
    return new Row(
      children: <Widget>[
        new Container(
          width: 300.0,
          child: new ListView(
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.call_received),
                title: new Text("Recently played",
                    style: new TextStyle(
                        color: selected == 1 ? Colors.blue : Colors.black)),
                subtitle: new Text("songs"),
                onTap: () {
                  setState(() {
                    mode = 1;
                    selected = 1;
                  });
                },
              ),
              new ListTile(
                leading: new Icon(Icons.show_chart),
                title: new Text("Top tracks",
                    style: new TextStyle(
                        color: selected == 2 ? Colors.blue : Colors.black)),
                subtitle: new Text("songs"),
                onTap: () {
                  setState(() {
                    mode = 2;
                    selected = 2;
                  });
                },
              ),
              new ListTile(
                leading: new Icon(Icons.favorite),
                title: new Text("Favourites",
                    style: new TextStyle(
                        color: selected == 3 ? Colors.blue : Colors.black)),
                subtitle: new Text("Songs"),
                onTap: () {
                  setState(() {
                    mode = 3;
                    selected = 3;
                  });
                },
              ),
            ],
          ),
        ),
        new Expanded(
            child: new Container(
          child: new ListSongs(widget.db, mode, orientation),
        ))
      ],
    );
  }
}
