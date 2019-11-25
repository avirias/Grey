import 'dart:async';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/AAppBar.dart';
import 'package:musicplayer/util/lastplay.dart';
import 'package:musicplayer/views/album.dart';
import 'package:musicplayer/views/artists.dart';
import 'package:musicplayer/views/home.dart';
import 'package:musicplayer/views/playlists.dart';
import 'package:musicplayer/views/songs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BodySelection extends StatelessWidget {
  BodySelection(this._selectedIndex, this.db);

  final DatabaseClient db;
  final int _selectedIndex;

  _selectionPage(int pos) {
    switch (pos) {
      case 0:
        return Home(db);
      case 2:
        return Songs(db);
      case 3:
        return Artists(db);
      case 1:
        return Album(db);
      case 4:
        return Playlist(db);
      default:
        return Text("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _selectionPage(_selectedIndex);
  }
}

class MusicHome extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new _MusicState();
  }
}

class _MusicState extends State<MusicHome> {
  int _selectedIndex = 0;
  int serIndex;
  List<Song> songs;
  List<String> title = ["", "Albums", "Songs", "Artists", "Playlists"];
  DatabaseClient db;
  bool isLoading = true;
  Song last;
  List<BottomItem> bottomItems;
  List<dynamic> bottomOptions;

  _onSelectItem(int index) {
    setState(() => _selectedIndex = index);
  }

  bool _handlingIsSelected(int pos) {
    return _selectedIndex == pos;
  }

  initBottomItems() {
    bottomItems = [
      new BottomItem("Home", Icons.home, null, null),
      new BottomItem("Albums", Icons.album, () async {
        _onSelectItem(1);
      }, _handlingIsSelected(1)),
      new BottomItem("Songs", Icons.music_note, () async {
        _onSelectItem(2);
      }, _handlingIsSelected(2)),
      new BottomItem("Artists", Icons.person, () async {
        _onSelectItem(3);
      }, _handlingIsSelected(3)),
      new BottomItem("Playlists", Icons.playlist_play, () async {
        _onSelectItem(4);
      }, _handlingIsSelected(4)),
    ];
    bottomOptions = <Widget>[];
    for (var i = 1; i < bottomItems.length; i++) {
      var d = bottomItems[i];
      if (i == 2 || i == 4) {
        bottomOptions.add(Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03)));
      }
      if (i == 3) {
        bottomOptions.add(Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15)));
      }
      bottomOptions.add(new IconButton(
        icon: Icon(d.icon,
            color: d.isSelected ? Color(0xff373a46) : Colors.blueGrey.shade600),
        onPressed: d.onPressed,
        tooltip: d.tooltip,
        iconSize: 32.0,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
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
      for (Song song in list) db.insertOrUpdateSong(song);
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
    var db = new DatabaseClient();
    await MusicFinder.allSongs().then((songs) {
      List<Song> newSongs = List.from(songs);
      for (Song song in newSongs)  db.insertOrUpdateSong(song);
    }).then((val) {
      scaffoldState.currentState.showSnackBar(new SnackBar(
        content: Text(
          "Database Updated",
        ),
        duration: Duration(milliseconds: 1500),
      ));
    }).catchError((error) {
      scaffoldState.currentState.showSnackBar(new SnackBar(
        content: Text(
          "Failed to update database",
        ),
        duration: Duration(milliseconds: 1500),
      ));
    });
  }

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    initBottomItems();
    return new WillPopScope(
      child: new Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        key: scaffoldState,
        appBar: _selectedIndex == 0
            ? null
            : GreyAppBar(
                title: title[_selectedIndex].toLowerCase(),
              ),
        floatingActionButton: new FloatingActionButton(
            child: new FlutterLogo(
              colors: Colors.blueGrey,
              style: FlutterLogoStyle.markOnly,
            ),
            backgroundColor: Colors.white,
            onPressed: () async {
              var pref = await SharedPreferences.getInstance();
              var fp = pref.getBool("played");
              if (fp == null) {
                scaffoldState.currentState.showSnackBar(
                    new SnackBar(content: Text("Play your first song.")));
              } else {
                Navigator.of(context)
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
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : _selectedIndex == 0
                ? RefreshIndicator(
                    child: BodySelection(_selectedIndex, db),
                    color: Colors.blueGrey,
                    onRefresh: refreshData,
                    backgroundColor: Colors.white,
                  )
                : BodySelection(_selectedIndex, db),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            color: Colors.transparent,
            height: 55.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: bottomOptions),
          ),
          notchMargin: 10.0,
          elevation: 0.0,
          color: Colors.grey.withOpacity(0.25),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return null;
    } else
      return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
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
              );
            },
          ) ??
          false;
  }
}

class BottomItem {
  String tooltip;
  IconData icon;
  VoidCallback onPressed;
  bool isSelected;

  BottomItem(
      [this.tooltip, this.icon, this.onPressed, this.isSelected = false]);
}
