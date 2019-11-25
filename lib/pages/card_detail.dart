import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/artistcard.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/lastplay.dart';

class CardDetail extends StatefulWidget {
  var album;
  final Song song;
  DatabaseClient db;
  CardDetail(this.db, this.song);
  @override
  State<StatefulWidget> createState() {
    return new _StateCardDetail();
  }
}

class _StateCardDetail extends State<CardDetail> {
  List<Song> songs;

  bool isLoading = true;
  var image;
  @override
  void initState() {
    super.initState();
    initAlbum();
  }

  dynamic getImage(Song song) {
    return song.albumArt == null
        ? null
        : new File.fromUri(Uri.parse(song.albumArt));
  }

  void initAlbum() async {
    image = widget.song.albumArt == null
        ? null
        : new File.fromUri(Uri.parse(widget.song.albumArt));
    songs = await widget.db.fetchSongsFromAlbum(widget.song.albumId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int length;
    if (songs != null)
      length = songs.length;
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.white,
        child: isLoading
            ? new Center(
                child: new CircularProgressIndicator(),
              )
            : new CustomScrollView(slivers: <Widget>[
                new SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width,
                  forceElevated: false,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: new FlexibleSpaceBar(
                    title: Text(""),
                    background: new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Hero(
                          tag: widget.song.album,
                          child: widget.song.albumArt != null
                              ?  Image.file(
                                  image,
                                  fit: BoxFit.cover,
                                )
                              : new Image.asset("images/back.jpg",
                                  fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ),
                ),
                new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                    Container(
                      color: Colors.white.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 15.0, right: 10.0),
                                child: new Text(
                                  widget.song.album,
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Quicksand"),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                     return ArtistCard(widget.db, widget.song);
                                    }));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.person,
                                        size: 33.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              widget.song.artist,
                                              style: new TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                            ),
                                            length != 1
                                                ? new Text(
                                                    songs.length.toString() +
                                                        " Songs",
                                                    style: TextStyle(
                                                        fontSize: 13.0),
                                                  )
                                                : new Text(
                                                    songs.length.toString() +
                                                        " Song",
                                                    style: TextStyle(
                                                        fontSize: 13.0),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                new SliverList(
                  delegate: new SliverChildBuilderDelegate((builder, i) {
                    return Container(
                      color: Colors.white.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Container(
                          color: Colors.white,
                          child: new ListTile(
                            leading: Hero(
                                tag: songs[i].id,
                                child: songs[i].albumArt != null
                                 ? Image.file(
                                  getImage(songs[i]),
                                  width: 50.0,
                                  height: 50.0,
                                ) : Icon(Icons.music_note)),

                            title: new Text(
                              songs[i].title,
                              maxLines: 1,
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: new Text(
                                new Duration(milliseconds: songs[i].duration)
                                    .toString()
                                    .split('.')
                                    .first
                                    .substring(3, 7),
                                style: new TextStyle(
                                    fontSize: 12.0, color: Colors.grey)),
                            //trailing:
                            onTap: () {
                              MyQueue.songs = songs;
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      new NowPlaying(widget.db, songs, i, 0)));
                            },
                          ),
                        ),
                      ),
                    );
                  }, childCount: songs.length),
                ),
              ]),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          MyQueue.songs = songs;
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) =>
                  new NowPlaying(widget.db, MyQueue.songs, 0, 0)));
        },
        child: new Icon(CupertinoIcons.shuffle_thick),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey,
      ),
    );
  }
}
