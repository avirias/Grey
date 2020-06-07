import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/music_player.dart';
import 'package:musicplayer/pages/list_songs.dart';

class Playlists extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _StatePlaylist();
  }
}

class _StatePlaylist extends State<Playlists> {
  var mode;
  List<SongInfo> songs;
  var selected;
  String atFirst, atSecond, atThir;
  String nu = "null";
  Orientation orientation;
  FlutterAudioQuery audioQuery;

  @override
  void initState() {
    super.initState();
//    _lengthFind();
//    setState(() {
//    });
    mode = 1;
    selected = 1;
    audioQuery = FlutterAudioQuery();
    init();

    MusicPlayer musicPlayer = MusicPlayer();
  }

  @override
  void dispose() {
    super.dispose();
  }

//  _lengthFind() async {
//    var random = Random();
//    songs = await widget.db.fetchRecentSong();
//    setState(() {
//      atFirst = songs[random.nextInt(songs.length-1)].artist;
//    });
//    songs = await widget.db.fetchTopSong();
//    setState(() {
//      atSecond = songs[random.nextInt(songs.length-1)].artist;
//    });
//    songs = await widget.db.fetchFavSong();
//    String atThird = "No Songs in favorites";
//    setState(() {
//      atThir = songs.length != 0
//          ? "Includes ${songs[random.nextInt(songs.length-1)].artist.toString()} and more"
//          : atThird;
//    });
//
//  }

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return new Container(
      child: portrait(),
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
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
//          subtitle: new Text(
//            "Includes ${atFirst!=null?atFirst:nu} and more",
//            maxLines: 1,
//          ),
          onTap: () async {
            // TODO: Recently played
            FlutterAudioQuery _audioQuery = FlutterAudioQuery();
            List<SongInfo> songs = await _audioQuery.getSongs();
            Navigator.of(context)
                .push(new CupertinoPageRoute(builder: (context) {
              return new ListSongs(
                title: "Recently played",
                songs: songs,
              );
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
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
//          subtitle: new Text(
//            "Includes ${atSecond!=null?atSecond:nu} and more",
//            maxLines: 1,
//          ),
          onTap: () async {
            // TODO: Top tracks
            FlutterAudioQuery _audioQuery = FlutterAudioQuery();
            List<SongInfo> songs = await _audioQuery.getSongs();
            Navigator.of(context)
                .push(new CupertinoPageRoute(builder: (context) {
              return new ListSongs(
                title: "Top tracks",
                songs: songs,
              );
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
//          subtitle: new Text(
//            atThir!=null?atThir:nu,
//            maxLines: 1,
//          ),
          onTap: () async {
            // TODO: Favorites
            FlutterAudioQuery _audioQuery = FlutterAudioQuery();
            List<SongInfo> songs = await _audioQuery.getSongs();
            Navigator.of(context)
                .push(new CupertinoPageRoute(builder: (context) {
              return new ListSongs(
                title: "Favourites",
                songs: songs,
              );
            }));
          },
        ),
      ],
    );
  }

  init() async {
    await audioQuery.getPlaylists().then((val) {
      print("size${val.length}");
      val.forEach((f) {
        print("object");
        print(f.name);
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

//  Widget landscape() {
//    return new Row(
//      children: <Widget>[
//        new Container(
//          width: 300.0,
//          child: new ListView(
//            children: <Widget>[
//              new ListTile(
//                leading: new Icon(Icons.call_received),
//                title: new Text("Recently played",
//                    style: new TextStyle(
//                        color: selected == 1 ? Colors.blue : Colors.black)),
//                subtitle: new Text("songs"),
//                onTap: () {
//                  setState(() {
//                    mode = 1;
//                    selected = 1;
//                  });
//                },
//              ),
//              new ListTile(
//                leading: new Icon(Icons.show_chart),
//                title: new Text("Top tracks",
//                    style: new TextStyle(
//                        color: selected == 2 ? Colors.blue : Colors.black)),
//                subtitle: new Text("songs"),
//                onTap: () {
//                  setState(() {
//                    mode = 2;
//                    selected = 2;
//                  });
//                },
//              ),
//              new ListTile(
//                leading: new Icon(Icons.favorite),
//                title: new Text("Favourites",
//                    style: new TextStyle(
//                        color: selected == 3 ? Colors.blue : Colors.black)),
//                subtitle: new Text("Songs"),
//                onTap: () {
//                  setState(() {
//                    mode = 3;
//                    selected = 3;
//                  });
//                },
//              ),
//            ],
//          ),
//        ),
//        new Expanded(
//            child: new Container(
//          child: new ListSongs(mode),
//        ))
//      ],
//    );
//  }
}
