import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';
import 'package:musicplayer/pages/artist_detail.dart';
import 'package:musicplayer/util/theme.dart';
import 'package:musicplayer/widgets/player/player.dart';
import 'package:musicplayer/widgets/player/playing_progress.dart';

class NowPlaying extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _StateNowPlaying();
  }
}

class _StateNowPlaying extends State<NowPlaying>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;

  @override
  void initState() {
    super.initState();
    initAnim();
    if (context.player.playbackState.state == PlayerState.Paused)
      _animationController.value = 1.0;
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
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
      begin: Colors.blueGrey[400].withOpacity(0.7),
      end: Colors.blueGrey[400].withOpacity(0.9),
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

  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final metadata = context.listenPlayerValue.metadata;
    final double cutRadius = 8.0;
    return new Scaffold(
      key: scaffoldState,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Container(
              height: width,
              color: Colors.white,
              child: metadata.iconUri != null
                  ? Image.file(
                      File(metadata.iconUri),
                      fit: BoxFit.fitWidth,
                      height: width,
                      width: width,
                    )
                  : Image.asset(
                      "images/music.jpg",
                      fit: BoxFit.fitWidth,
                      width: width,
                    )),
          Positioned(
            top: width,
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height - width,
              width: width,
            ),
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              height: width,
              decoration:
                  new BoxDecoration(color: Colors.grey[700].withOpacity(0.3)),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: width * 0.065 * 2),
              child: Container(
                width: width - 2 * width * 0.04,
                height: width - 2 * width * 0.04,
                child: Hero(
                  tag: metadata.mediaId,
                  child: metadata.iconUri != null
                      ? Material(
                          color: Colors.transparent,
                          elevation: 22.0,
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(cutRadius),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(
                                    image: FileImage(File(metadata.iconUri)),
                                    fit: BoxFit.cover)),
                          ),
                        )
                      : Material(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(cutRadius)),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image.asset(
                                "images/back.jpg",
                                fit: BoxFit.fitHeight,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),

          /**
           *  Slider and all buttons with texts
           */
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: width * 1.11),
              child: Container(
                height: MediaQuery.of(context).size.height - width * 1.11,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ProgressTrackingContainer(
                        builder: (context) => PlayingProgressCont(),
                        player: context.player),

                    /**
                     * Song title and Artist name
                     */
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, top: 5),
                              child: new Text(
                                '${context.listenPlayerValue.metadata.title.toUpperCase()}\n',
                                style: new TextStyle(
                                    color: Colors.black.withOpacity(0.65),
                                    fontSize: 17,
                                    fontFamily: "Quicksand",
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    new MaterialPageRoute(builder: (context) {
                                  return new ArtistDetail(context
                                      .listenPlayerValue.metadata.subtitle);
                                }));
                              },
                              child: new Text(
                                "${context.listenPlayerValue.metadata.subtitle.toUpperCase()}\n",
                                style: new TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontFamily: "Quicksand",
                                    letterSpacing: 1.8,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /**
                     * Control buttons
                     */
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new IconButton(
                                  icon: new Icon(
                                    Icons.favorite_border,
                                    color: accentColor,
                                    size: 15.0,
                                  ),
//                                    : new Icon(
//                                        Icons.favorite,
//                                        color: accentColor,
//                                        size: 15.0,
//                                      ),
                                  onPressed: () {}),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0)),
                              new IconButton(
                                splashColor: Colors.blueGrey[200],
                                highlightColor: Colors.transparent,
                                icon: new Icon(
                                  Icons.skip_previous,
                                  color: accentColor,
                                  size: 32.0,
                                ),
                                onPressed: () {
                                  PlayerWidget.transportControls(context)
                                      .skipToPrevious();
                                },
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 20.0, right: 20.0),
                                child: FloatingActionButton(
                                  backgroundColor: _animateColor.value,
                                  child: new AnimatedIcon(
                                      icon: AnimatedIcons.pause_play,
                                      progress: _animateIcon),
                                  onPressed: () {
                                    final playbackState =
                                        PlayerStateWidget.of(context)
                                            .playbackState;
                                    if (playbackState.state ==
                                        PlayerState.Playing) {
                                      PlayerWidget.transportControls(context)
                                          .pause();
                                      animateForward();
                                    } else {
                                      PlayerWidget.transportControls(context)
                                          .play();
                                      animateReverse();
                                    }
                                  },
                                ),
                              ),
                              new IconButton(
                                splashColor:
                                    Colors.blueGrey[200].withOpacity(0.5),
                                highlightColor: Colors.transparent,
                                icon: new Icon(
                                  Icons.skip_next,
                                  color: accentColor,
                                  size: 32.0,
                                ),
                                onPressed: () {
                                  PlayerWidget.transportControls(context)
                                      .skipToNext();
                                },
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0)),
                              RepeatModelButton()
                            ],
                          ),
                        ),
                      ),
                    ),

                    /**
                     * Up next
                     */
                    Center(
                      child: FlatButton(
                        shape: StadiumBorder(),
                        onPressed: _showBottomSheet,
                        highlightColor: Colors.blueGrey[200].withOpacity(0.1),
                        child: Text(
                          "UP NEXT",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.bold),
                        ),
                        splashColor: Colors.blueGrey[200].withOpacity(0.1),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0))),
                  color: Color(0xFFFAFAFA)),
              height: MediaQuery.of(context).size.height * 0.5,
              child: Scrollbar(
                child: new ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: context.player.queue.queue.length,
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10.0),
                    itemBuilder: (context, index) {
                      var song = context.player.queue.queue.elementAt(index);
                      return Column(
                        children: <Widget>[
                          new ListTile(
                            leading: Icon(Icons.music_note),
                            title: new Text(
                              song.title,
                              maxLines: 1,
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                new Text(
                                  song.subtitle,
                                  maxLines: 1,
                                  style: new TextStyle(color: Colors.black54),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
                                  child: Text("."),
                                ),
                                Text(song.duration.formatAsTimeStamp(),
                                    style: new TextStyle(color: Colors.black54))
                              ],
                            ),
                            trailing: song.mediaId ==
                                    context.listenPlayerValue.metadata.mediaId
                                ? new Icon(Icons.play_circle_filled,
                                    color: Colors.blueGrey[700])
                                : null,
                            onTap: () {
                              setState(() {
                                //TODO: Play tapped song
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ],
                      );
                    }),
              ));
        });
  }
}

class RepeatModelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MusicPlayerValue state = PlayerStateWidget.of(context);

    Widget icon;
    if (state.playMode == PlayMode.shuffle) {
      icon = const Icon(Icons.shuffle);
    } else if (state.playMode == PlayMode.single) {
      icon = const Icon(Icons.repeat_one);
    } else {
      icon = const Icon(Icons.repeat);
    }
    return IconButton(
        icon: icon,
        iconSize: 15,
        color: accentColor,
        onPressed: () {
          PlayerWidget.transportControls(context)
              .setPlayMode(_getNext(state.playMode));
        });
  }

  static PlayMode _getNext(PlayMode playMode) {
    if (playMode == PlayMode.sequence) {
      return PlayMode.shuffle;
    } else if (playMode == PlayMode.shuffle) {
      return PlayMode.single;
    } else if (playMode == PlayMode.single) {
      return PlayMode.sequence;
    }
    throw "can not reach";
  }
}
