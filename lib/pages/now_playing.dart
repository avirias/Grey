import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/util/lastplay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';

class NowPlaying extends StatefulWidget {
  int mode;
  List<Song> songs;
  int index;
  DatabaseClient db;
  NowPlaying(this.db, this.songs, this.index, this.mode);
  @override
  State<StatefulWidget> createState() {
    return new _stateNowPlaying();
  }
}

class _stateNowPlaying extends State<NowPlaying>
    with SingleTickerProviderStateMixin {
  MusicFinder player;
  Duration duration;
  Duration position;
  bool isPlaying = false;
  Song song;
  int isfav = 1;
  int repeatOn = 0;
  Orientation orientation;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  bool isOpened = true;
  Animation<double> _animateIcon;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAnim();
    //  SystemChrome.setPreferredOrientations(
    //    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    initPlayer();
  }

  initAnim() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: accentColor.withOpacity(0.8),
      end: accentColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
  }

  animateForward() {
    _animationController.forward();
  }

  animateReverse() {
    _animationController.reverse();
  }

  void initPlayer() async {
    if (player == null) {
      player = MusicFinder();
      MyQueue.player = player;
      var pref = await SharedPreferences.getInstance();
      pref.setBool("played", true);
    }
    //  int i= await widget.db.isfav(song);
    setState(() {
      if (widget.mode == 0) {
        player.stop();
      }
      updatePage(widget.index);
      isPlaying = true;
    });
    player.setDurationHandler((d) => setState(() {
          duration = d;
        }));
    player.setPositionHandler((p) => setState(() {
          position = p;
        }));
    player.setCompletionHandler(() {
      onComplete();
      setState(() {
        position = duration;
        if (repeatOn != 1) ++widget.index;
        song = widget.songs[widget.index];
      });
    });
    player.setErrorHandler((msg) {
      setState(() {
        player.stop();
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  void updatePage(int index) {
    MyQueue.index = index;
    song = widget.songs[index];
    song.timestamp = new DateTime.now().millisecondsSinceEpoch;
    if (song.count == null) {
      song.count = 0;
    } else {
      song.count++;
    }
    widget.db.updateSong(song);
    isfav = song.isFav;
    player.play(song.uri);
    animateReverse();
    setState(() {
      isPlaying = true;
    });
  }

  void _playpause() {
    if (isPlaying) {
      player.pause();
      animateForward();
      setState(() {
        isPlaying = false;
        //  song = widget.songs[widget.index];
      });
    } else {
      player.play(song.uri);
      animateReverse();
      setState(() {
        //song = widget.songs[widget.index];
        isPlaying = true;
      });
    }
  }

  Future next() async {
    player.stop();
    // int i=await widget.db.isfav(song);
    setState(() {
      int i = widget.index + 1;
      if (repeatOn != 1) ++widget.index;

      if (i >= widget.songs.length) {
        i = widget.index = 0;
      }

      updatePage(widget.index);
    });
  }

  Future prev() async {
    player.stop();
    //   int i=await  widget.db.isfav(song);
    setState(() {
      int i = --widget.index;
      if (i < 0) {
        widget.index = 0;
        i = widget.index;
      }
      updatePage(i);
    });
  }

  void onComplete() {
    next();
  }

  dynamic getImage(Song song) {
    return song.albumArt == null
        ? null
        : new File.fromUri(Uri.parse(song.albumArt));
  }

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      key: scaffoldState,
      body: potrait(),
      backgroundColor: Colors.white,
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
              height: 450.0,
              child: Scrollbar(
                child: new ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: widget.songs.length,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.08,
                      right: MediaQuery.of(context).size.width * 0.08,
                      top: 10.0),
                  itemBuilder: (context, i) => new Column(
                        children: <Widget>[
                          new ListTile(
                            leading: new CircleAvatar(
                              child: getImage(widget.songs[i]) != null
                                  ? new Image.file(
                                      getImage(widget.songs[i]),
                                      height: 120.0,
                                      fit: BoxFit.cover,
                                    )
                                  : new Text(
                                      widget.songs[i].title[0].toUpperCase()),
                            ),
                            title: new Text(widget.songs[i].title,
                                maxLines: 1,
                                style: new TextStyle(fontSize: 16.0)),
                            subtitle: Row(
                              children: <Widget>[
                                new Text(
                                  widget.songs[i].artist,
                                  maxLines: 1,
                                  style: new TextStyle(
                                      fontSize: 12.0, color: Colors.black54),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: Text("-"),
                                ),
                                Text(
                                    new Duration(
                                            milliseconds:
                                                widget.songs[i].duration)
                                        .toString()
                                        .split('.')
                                        .first
                                        .substring(3, 7),
                                    style: new TextStyle(
                                        fontSize: 11.0, color: Colors.black54))
                              ],
                            ),
                            trailing: widget.songs[i].id ==
                                    MyQueue.songs[MyQueue.index].id
                                ? new Icon(Icons.play_circle_filled,
                                    color: darkAccentColor)
                                : null,
                            onTap: () {
                              setState(() {
                                MyQueue.index = i;
                                player.stop();
                                updatePage(MyQueue.index);
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ],
                      ),
                ),
              ));
        });
  }

  Widget potrait() {
    double width = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Stack(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height,
            child: getImage(song) != null
                  ? Image.file(
                      getImage(song),
                      fit: BoxFit.fitHeight,
                    )
                  : Image.asset("images/music.jpg")),
        BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration:
                new BoxDecoration(color: Colors.grey[900].withOpacity(0.5)),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: statusBarHeight),
                  child: new Container(),
                ),
                new Container(
                    child: new Column(
                  children: <Widget>[
                    Container(
                      width: width,
                      height: width,
                      child: Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(
                                style: BorderStyle.solid,
                                width: 0.0,
                                color: Colors.transparent)),
                        margin: const EdgeInsets.only(
                            top: 28.0, left: 28.0, right: 28.0, bottom: 20.0),
                        child: new AspectRatio(
                          aspectRatio: 15 / 15,
                          child: Hero(
                            tag: song.id,
                            child: getImage(song) != null
                            ? new Image.file(
                                getImage(song),
                                fit: BoxFit.cover,
                              )
                            : new Image.asset(
                                "images/back.jpg",
                                fit: BoxFit.fitHeight,
                              ),
                          ),
                        ),
                      ),
                    ),
                    new Slider(
                      min: 0.0,
                      activeColor: Colors.white.withOpacity(0.8),
                      inactiveColor: Colors.white.withOpacity(0.4),
                      value: position?.inMilliseconds?.toDouble() ?? 0.0,
                      onChanged: (double value) =>
                          player.seek((value / 1000).roundToDouble()),
                      max: song.duration.toDouble() + 1000,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, bottom: 10.0),
                          child: new Text(
                              position
                                  .toString()
                                  .split('.')
                                  .first
                                  .substring(3, 7),
                              // ignore: conflicting_dart_import
                              style: new TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0)),
                        ),
                        new Padding(
                          padding:
                              const EdgeInsets.only(right: 16.0, bottom: 10.0),
                          child: new Text(
                              new Duration(milliseconds: song.duration)
                                  .toString()
                                  .split('.')
                                  .first
                                  .substring(3, 7),
                              style: new TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0)),
                        ),
                      ],
                    ),
                  ],
                )),
                Expanded(
                  child: Center(
                    child: Container(
                      color: Colors.white.withOpacity(0.1),
                      child: Column(
                        children: <Widget>[
                          new Expanded(
                            child: Container(),
                          ),
                          new Text(
                            '${song.title.toUpperCase()}\n',
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3.0,
                                height: 1.5,
                                fontFamily: "Quicksand"),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          new Text(
                            "${song.artist.toUpperCase()}\n",
                            style: new TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14.0,
                                letterSpacing: 1.8,
                                height: 1.5,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Quicksand"),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new IconButton(
                              icon: isfav == 0
                                  ? new Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 15.0,
                                    )
                                  : new Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 15.0,
                                    ),
                              onPressed: () {
                                setFav(song);
                              }),
                          new IconButton(
                            splashColor: lightAccentColor,
                            highlightColor: Colors.transparent,
                            icon: new Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                              size: 32.0,
                            ),
                            onPressed: prev,
                          ),
                          FloatingActionButton(
                            backgroundColor: _animateColor.value,
                            child: new AnimatedIcon(
                                icon: AnimatedIcons.pause_play,
                                progress: _animateIcon),
                            onPressed: _playpause,
                          ),
                          new IconButton(
                            splashColor: lightAccentColor.withOpacity(0.5),
                            highlightColor: Colors.transparent,
                            icon: new Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 32.0,
                            ),
                            onPressed: next,
                          ),
                          new IconButton(
                            icon: (repeatOn == 1)
                                ? Icon(
                                    Icons.repeat,
                                    color: Colors.white,
                                    size: 15.0,
                                  )
                                : Icon(
                                    Icons.repeat,
                                    color: Colors.white.withOpacity(0.5),
                                    size: 15.0,
                                  ),
                            onPressed: () {
                              if (repeatOn == 1)
                                repeatOn = 0;
                              else if (repeatOn == 0) repeatOn = 1;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width,
                  color: Colors.white.withOpacity(0.1),
                  child: FlatButton(
                    onPressed: _showBottomSheet,
                    highlightColor: lightAccentColor.withOpacity(0.1),
                    child: Text(
                      "UP NEXT",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 2.0,
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold),
                    ),
                    splashColor: lightAccentColor.withOpacity(0.1),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> setFav(song) async {
    int i = await widget.db.favSong(song);
    setState(() {
      if (isfav == 1)
        isfav = 0;
      else
        isfav = 1;
    });
  }
}
