import 'dart:async';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/material_search.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/lastplay.dart';
import 'package:musicplayer/views/album.dart';
import 'package:musicplayer/views/artists.dart';
import 'package:musicplayer/views/home.dart';
import 'package:musicplayer/views/playlists.dart';
import 'package:musicplayer/views/songs.dart';
import 'package:shared_preferences/shared_preferences.dart';



class MusicHome extends StatefulWidget {
  List<Song> songs;
  MusicHome();
  final bottomItems = [
    new BottomItem("Home", Icons.home),
    new BottomItem("Albums", Icons.album),
    new BottomItem("Songs", Icons.music_note),
    new BottomItem("Artists", Icons.person),
    new BottomItem("Playlists", Icons.playlist_play),
  ];
  @override
  State<StatefulWidget> createState() {
    return new _musicState();
  }
}

class _musicState extends State<MusicHome> {
  int _selectedDrawerIndex = 0;
  int serIndex;
  List<Song> songs;
  String title = "";
  DatabaseClient db;
  bool isLoading = true;
  Song last;

  getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Home(db);
      case 2:
        return new Songs(db);
      case 3:
        return new Artists(db);
      case 1:
        return new Album(db);
      case 4:
        return new PlayList(db);
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    getDrawerItemWidget(_selectedDrawerIndex);
    title = widget.bottomItems[index].title;

  }

  @override
  void initState() {

    super.initState();
    initPlayer();
    getSharedData();
    
  }
  getSharedData() async {
    const platform = const MethodChannel('app.channel.shared.data');
    Map sharedData = await platform.invokeMethod("getSharedData");
    if (sharedData != null) {
      if (sharedData["albumArt"] == "null") {
        sharedData["albumArt"] = null;
      }
      Song song = new Song(
          9999 /*random*/,
          sharedData["artist"],
          sharedData["title"],
          sharedData["album"],
          null,
          int.parse(sharedData["duration"]),
          sharedData["uri"],
          sharedData["albumArt"]);
      List<Song> list = new List();
      list.add((song));
      MyQueue.songs = list;
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
        return new NowPlaying(null, list, 0, 0);
      }));
    }
  }



  void initPlayer() async {
    db = new DatabaseClient();
    await db.create();
    if (await db.alreadyLoaded()) {
      setState(() {
        isLoading = false;
        getLast();
      });
    } else {
      var songs;
      try {
        songs = await MusicFinder.allSongs();
      } catch (e) {
        print("failed to get songs");
      }
      List<Song> list = new List.from(songs);
      for (Song song in list) db.upsertSOng(song);
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
        getLast();
      });
    }
  }

    @override
  void dispose() {
    super.dispose();
  }

  void getLast() async {
    last = await db.fetchLastSong();
    songs = await db.fetchSongs();
    setState(() {
      songs = songs;
    });
  }

  Future<Null> refreshData() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      isLoading = true;
    });
    var db = new DatabaseClient();
    var res = await db.insertSongs();
    if(!res)
      {
        setState(() {
          isLoading = false;
          scaffoldState.currentState.showSnackBar(
              new SnackBar(content: Text("Failed to update database",style: TextStyle(fontFamily: "Quicksand"),),duration: Duration(milliseconds: 1500),));
        });
      }
      else
        setState(() {
          isLoading = false;
          scaffoldState.currentState.showSnackBar(
              new SnackBar(content: Text("Database Updated",style: TextStyle(fontFamily: "Quicksand"),),duration: Duration(milliseconds: 1500),));
        });
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    var bottomOptions = <BottomNavigationBarItem>[];
    for (var i = 0; i < widget.bottomItems.length; i++) {
      var d = widget.bottomItems[i];
      bottomOptions.add(
        new BottomNavigationBarItem(
            icon: new Icon(d.icon),
            title: new Text(d.title,style: TextStyle(fontWeight: FontWeight.w500,),),
            backgroundColor: Colors.blueGrey[200]),
      );
    }



    return new WillPopScope(
      child: new Scaffold(
        key: scaffoldState,
        appBar: _selectedDrawerIndex == 0
            ? null
            : new AppBar(

                //elevation: 5.0,
                backgroundColor: Colors.blueGrey[600],
                elevation: 3.0,
                title: new Text(title,style: TextStyle(color: Colors.white,fontSize: 20.0,fontFamily: "Quicksand",fontWeight: FontWeight.w600)),
                actions: <Widget>[
                  new IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        Navigator
                            .of(context)
                            .push(new MaterialPageRoute(builder: (context) {
                          return new SearchSong(db, songs);
                        }));

                      })
                ],
              ),
        floatingActionButton: new FloatingActionButton(
            child: new FlutterLogo(colors: Colors.blueGrey,style: FlutterLogoStyle.markOnly,curve: Curves.bounceInOut,),
            backgroundColor: Colors.white,
  
            onPressed: () async {
              var pref = await SharedPreferences.getInstance();
              var fp = pref.getBool("played");
              print("fp=====$fp");
              if (fp == null) {
                scaffoldState.currentState.showSnackBar(
                    new SnackBar(content: Text("Play your first song.")));
              } else {
                Navigator
                    .of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                  if (MyQueue.songs == null) {
                    List<Song> list = new List();
                    list.add(last);
                    MyQueue.songs = list;
                    return new NowPlaying(db, list, 0, 0);
                  } else
                    return new NowPlaying(db, MyQueue.songs, MyQueue.index, 1);
                }));
              }
            }),
        body: RefreshIndicator(
          color: Colors.blueGrey,
          child: isLoading
              ? new Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: new CircularProgressIndicator(),
                  ),
                )
              : getDrawerItemWidget(_selectedDrawerIndex),
          key: refreshKey,
          onRefresh: refreshData,
        ),
        bottomNavigationBar: new BottomNavigationBar(
          items: bottomOptions,
          onTap: (index) => _onSelectItem(index),
          currentIndex: _selectedDrawerIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.blueGrey[400],
          iconSize: 25.0,
        ),
      ),
      onWillPop: _onWillPop,
    );

  }

  Future<bool> _onWillPop() {
    if (_selectedDrawerIndex != 0) {
      setState(() {
        _selectedDrawerIndex = 0;
      });
      return null;
    } else
      return showDialog(
        context: context,
        child: new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Grey will be stopped..'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text(
                'No',
              ),
            ),
            new FlatButton(
              onPressed: () {
                MyQueue.player.stop();
                Navigator.of(context).pop(true);
              },
              child: new Text('Yes'),
            ),
          ],
        ),
      ) ??
          false;
  }
}


class BottomItem {
  String title;
  IconData icon;
  BottomItem(this.title, this.icon);
}
