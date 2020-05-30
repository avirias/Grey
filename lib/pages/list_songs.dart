import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/widgets/app_bar.dart';
import 'package:musicplayer/model/queue.dart';
import 'package:flutter/cupertino.dart';

class ListSongs extends StatefulWidget {
  final List<SongInfo> songs;
  final String title;

  const ListSongs({Key key, this.songs, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ListSong();
  }
}

class _ListSong extends State<ListSongs> {
  FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  void initState() {
    super.initState();
  }

//  void _modelBottomSheet() {
//    List<bool> isFavorite = new List(allSongs.length);
//    for (int m = 0; m < allSongs.length; m++) isFavorite[m] = false;
//    bool isFavoriteX;
//    showModalBottomSheet(
//        context: context,
//        builder: (builder) {
//          return Container(
//            decoration: ShapeDecoration(
//                shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.only(
//                        topLeft: Radius.circular(6.0),
//                        topRight: Radius.circular(6.0))),
//                color: Color(0xFFFAFAFA)),
//            child: Scrollbar(
//              child: ListView.builder(
//                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
//                itemCount: allSongs.length,
//                physics: BouncingScrollPhysics(),
//                itemBuilder: (context, i) {
//                  isFavoriteX = true;
//                  return ListTile(
//                    title: Text(allSongs[i].title,
//                        maxLines: 1,
//                        style: new TextStyle(
//                          color: Colors.black,
//                          fontSize: 16.0,
//                        )),
//                    leading: allSongs[i].albumArt != null
//                        ? Image.file(
//                            getImage(allSongs[i]),
//                            width: 55.0,
//                            height: 55.0,
//                          )
//                        : Icon(Icons.music_note),
//                    subtitle: new Text(
//                      allSongs[i].artist,
//                      maxLines: 1,
//                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
//                    ),
//                    trailing: RawMaterialButton(
//                        shape: CircleBorder(),
//                        child: !isFavorite[i] || isFavoriteX
//                            ? Icon(Icons.add)
//                            : Icon(Icons.remove),
//                        fillColor: Color(0xFFefece8),
//                        onPressed: () async {
//                          setState(() {
//                            isFavorite[i] = true;
//                            isFavoriteX = false;
//                          });
//                          await widget.db.favoriteSongsList(allSongs[i]);
//                        }),
//                    onTap: () {
//                      MyQueue.songs = allSongs;
//                      Navigator.of(context).push(new MaterialPageRoute(
//                          builder: (context) =>
//                              new NowPlaying(MyQueue.songs, i, 0)));
//                    },
//                  );
//                },
//              ),
//            ),
//          );
//        });
//  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: orientation == Orientation.portrait
          ? GreyAppBar(
              title: widget.title.toLowerCase(),
              isBack: true,
            )
          : null,
      body: new Container(
        child: widget.songs.length != 0
            ? new ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.songs.length,
                itemBuilder: (context, i) => new Column(
                  children: <Widget>[
                    new ListTile(
                      leading: Hero(
                        tag: widget.songs[i].id,
                        child: Icon(Icons.music_note),
                      ),
                      title: new Text(widget.songs[i].title,
                          maxLines: 1,
                          style: new TextStyle(
                              fontSize: 16.0, color: Colors.black)),
                      subtitle: new Text(
                        widget.songs[i].artist,
                        maxLines: 1,
                        style:
                            new TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      trailing: Text(
                          new Duration(
                                  milliseconds:
                                      int.parse(widget.songs[i].duration))
                              .toString()
                              .split('.')
                              .first
                              .substring(3, 7),
                          style: new TextStyle(
                              fontSize: 12.0, color: Colors.grey)),
                      onTap: () {
                        MyQueue.songs = widget.songs;
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) =>
                                new NowPlaying(MyQueue.songs, i, 0)));
                      },
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Nothing here :(",
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w600),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                    OutlineButton(
                      child: Text("Add Songs".toUpperCase()),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      onPressed: () {},
                      color: Colors.blueGrey.shade500,
                      highlightedBorderColor: Color(0xFF373737),
                      borderSide:
                          BorderSide(width: 2.0, color: Colors.blueGrey),
                    )
                  ],
                ),
              ),
      ),
      floatingActionButton: widget.songs != null
          ? FloatingActionButton(
              onPressed: () {
                MyQueue.songs = widget.songs;
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new NowPlaying(MyQueue.songs,
                        new Random().nextInt(widget.songs.length), 0)));
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueGrey,
              child: Icon(CupertinoIcons.shuffle_thick),
            )
          : null,
    );
  }
}
