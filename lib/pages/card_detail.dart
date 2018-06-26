import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/lastplay.dart';
import 'package:musicplayer/util/utility.dart';

import '../theme.dart';

class CardDetail extends StatefulWidget {
  int id;
  var album;
  Song song;
  DatabaseClient db;
  CardDetail(this.db, this.song);
  @override
  State<StatefulWidget> createState() {
    return new stateCardDetail();
  }
}

class stateCardDetail extends State<CardDetail> {
  List<Song> songs;

  bool isLoading = true;
  var image;
  @override
  void initState() {
    // TODO: implement initState
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
      songs = await widget.db.fetchSongsfromAlbum(widget.song.albumId);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int length = songs.length;
    return new Scaffold(
        body: isLoading
            ? new Center(
          child: new CircularProgressIndicator(),
        )
            :new CustomScrollView(
          slivers: <Widget>[
                new SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width,
                  forceElevated: false,
                  floating: false,
                  pinned: true,
                  backgroundColor: accentColor,
                  flexibleSpace: new FlexibleSpaceBar(
                    title: Text(""),
                    background: new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Hero(
                          tag: widget.song.album,
                          child: image != null
                              ? new Image.file(
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
                        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.only(left: 15.0,top: 15.0,right: 10.0),
                                child: new Text(
                                  widget.song.album,
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Quicksand"
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.person,size: 33.0,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            widget.song.artist,
                                            style: new TextStyle(fontSize: 17.0),
                                            maxLines: 1,
                                          ),
                                          length!=1
                                          ?new Text(songs.length.toString() +" Songs",style: TextStyle(fontSize: 13.0),)
                                          :new Text(songs.length.toString() +" Song",style: TextStyle(fontSize: 13.0),)
                                        ],
                                      ),
                                    ),
                                  ],
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
                        padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                        child: Container(
                          color: Colors.white,
                          child: new ListTile(
                            leading: Hero(tag: songs[i].id,child: Image.file(getImage(songs[i]),width: 50.0,height: 50.0,)),
                      
                            title: new Text(songs[i].title,
                                maxLines: 1, style: new TextStyle(fontSize: 15.0),overflow: TextOverflow.ellipsis,),
                            subtitle: new Text(
                                new Duration(milliseconds: songs[i].duration)
                                    .toString()
                                    .split('.')
                                    .first.substring(3,7),
                                style: new TextStyle(
                                    fontSize: 12.0, color: Colors.grey)) ,
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


              ]
        ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          MyQueue.songs = songs;
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) =>
              new NowPlaying(widget.db, MyQueue.songs, 0, 0)));
        },
        child: new Icon(Icons.shuffle),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
