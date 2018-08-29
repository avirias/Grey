import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/AAppBar.dart';
import 'package:musicplayer/util/lastplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicplayer/util/utility.dart';

class ListSongs extends StatefulWidget {
  DatabaseClient db;
  int mode;
  Orientation orientation;
  // mode =1=>recent, 2=>top, 3=>fav
  ListSongs(this.db, this.mode, this.orientation);
  @override
  State<StatefulWidget> createState() {
    return new _listSong();
  }
}

class _listSong extends State<ListSongs> {
  List<Song> songs, allSongs;
  bool isLoading = true;
  dynamic getImage(Song song) {
    return song.albumArt == null
        ? null
        : new File.fromUri(Uri.parse(song.albumArt));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSongs();
  }

  void initSongs() async {
    allSongs = await widget.db.fetchSongs();
    switch (widget.mode) {
      case 1:
        songs = await widget.db.fetchRecentSong();
        break;
      case 2:
        songs = await widget.db.fetchTopSong();
        break;
      case 3:
        songs = await widget.db.fetchFavSong();
        break;
      default:
        break;
    }
    setState(() {
      isLoading = false;
    });
  }

  String getTitle(int mode) {
    switch (mode) {
      case 1:
        return "Recently played";
        break;
      case 2:
        return "Top tracks";
        break;
      case 3:
        return "Favourites";
        break;
      default:
        return null;
    }
  }

  Future<bool> isFav(song) async {
    if (await widget.db.isfav(song) == 0)
      return true;
    else
      return false;
  }

  void _modelbottomSheet() {
    List<bool> isFavorite = new List(allSongs.length);
    for (int m = 0; m < allSongs.length; m++) isFavorite[m] = false;
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            child: Scrollbar(
              child: ListView.builder(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                itemCount: allSongs.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(allSongs[i].title,
                        maxLines: 1,
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        )),
                    leading: Image.file(
                      getImage(allSongs[i]),
                      width: 55.0,
                      height: 55.0,
                    ),
                    subtitle: new Text(
                      allSongs[i].artist,
                      maxLines: 1,
                      style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    trailing: RawMaterialButton(
                        shape: CircleBorder(),
                        child: !isFavorite[i]
                            ? Icon(Icons.add)
                            : Icon(Icons.remove),
                        fillColor: Color(0xFFefece8),
                        onPressed: () async {
                          setState(() {
                            isFavorite[i] = true;
                          });
                          await widget.db.favSong(allSongs[i]);
                        }),
                    onTap: () {
                      MyQueue.songs = allSongs;
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) =>
                              new NowPlaying(widget.db, MyQueue.songs, i, 0)));
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    initSongs();
    return new Scaffold(
      appBar: widget.orientation == Orientation.portrait
          ? AAppBar(title: getTitle(widget.mode),isBack: true,)
          : null,
      body: new Container(
        child: isLoading
            ? new Center(
                child: new CircularProgressIndicator(),
              )
            : songs.length != 0
                ? new ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, i) => new Column(
                          children: <Widget>[
                            new ListTile(
                              leading: Hero(
                                tag: songs[i].id,
                                child: Image.file(
                                  getImage(songs[i]),
                                  width: 55.0,
                                  height: 55.0,
                                ),
                              ),
                              title: new Text(songs[i].title,
                                  maxLines: 1,
                                  style: new TextStyle(
                                      fontSize: 16.0, color: Colors.black)),
                              subtitle: new Text(
                                songs[i].artist,
                                maxLines: 1,
                                style: new TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              ),
                              trailing: widget.mode == 2
                                  ? new Text(
                                      (i + 1).toString(),
                                      style: new TextStyle(
                                          fontSize: 12.0, color: Colors.grey),
                                    )
                                  : new Text(
                                      new Duration(
                                              milliseconds: songs[i].duration)
                                          .toString()
                                          .split('.')
                                          .first
                                          .substring(3, 7),
                                      style: new TextStyle(
                                          fontSize: 12.0, color: Colors.grey)),
                              onTap: () {
                                MyQueue.songs = songs;
                                Navigator.of(context).push(
                                    new MaterialPageRoute(
                                        builder: (context) => new NowPlaying(
                                            widget.db, MyQueue.songs, i, 0)));
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
                          style: TextStyle(fontSize: 25.0),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 10.0)),
                        OutlineButton(
                          child: Text("Add Songs".toUpperCase()),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onPressed: _modelbottomSheet,
                          color: Colors.blueGrey.shade500,
                          highlightedBorderColor: Color(0xFFf08f8f),
                          borderSide:
                              BorderSide(width: 2.0, color: Colors.blueGrey),
                        )
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MyQueue.songs = songs;
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new NowPlaying(widget.db, MyQueue.songs,
                  new Random().nextInt(songs.length), 0)));
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey,
        child: Icon(CupertinoIcons.shuffle_thick),
      ),
    );
  }
}
