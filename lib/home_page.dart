import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/theme.dart';
import 'package:musicplayer/views/albums.dart';
import 'package:musicplayer/views/artists.dart';
import 'package:musicplayer/views/home.dart';
import 'package:musicplayer/views/playlists.dart';
import 'package:musicplayer/views/songs.dart';
import 'package:musicplayer/widgets/app_bar.dart';
import 'package:musicplayer/widgets/player/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BodySelection extends StatelessWidget {
  BodySelection(this._selectedIndex);

  final int _selectedIndex;

  _selectionPage(int pos) {
    switch (pos) {
      case 0:
        return Home();
      case 2:
        return Songs();
      case 3:
        return Artists();
      case 1:
        return Albums();
      case 4:
        return Playlists();
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
  List<SongInfo> songs;
  List<String> title = ["", "Albums", "Songs", "Artists", "Playlists"];
  bool isLoading = true;
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
    isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              colors: accentColor,
              style: FlutterLogoStyle.markOnly,
            ),
            backgroundColor: Colors.white,
            onPressed: () async {
              var pref = await SharedPreferences.getInstance();
              var fp = pref.getBool("played");
              if (fp == null) {
                scaffoldState.currentState.showSnackBar(new SnackBar(
                  content: Text("Play your first song."),
                  duration: Duration(milliseconds: 1500),
                ));
              } else {
                // TODO: Play last song
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                  return new NowPlaying();
                }));
              }
            }),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : BodySelection(_selectedIndex),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                ),
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
                      PlayerWidget.transportControls(context).pause();
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
