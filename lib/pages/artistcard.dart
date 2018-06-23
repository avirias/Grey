import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/card_detail.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/lastplay.dart';
import 'package:musicplayer/util/utility.dart';

import '../theme.dart';

class ArtistCard extends StatefulWidget {
  int id;
  Song song;
  DatabaseClient db;
  ArtistCard(this.db, this.song);
  @override
  State<StatefulWidget> createState() {
    return new stateCardDetail();
  }
}

class stateCardDetail extends State<ArtistCard> {
  List<Song> songs;
    List<Song> albums;

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
    
    songs = await widget.db.fetchSongsByArtist(widget.song.artist);
    albums = await widget.db.fetchAlbumByArtist(widget.song.artist);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    title: Text(widget.song.artist,style: TextStyle(color: Colors.white,fontSize: 18.0,fontFamily: "Raleway",fontWeight: FontWeight.w600,letterSpacing: 2.0),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    background: new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        image != null
                            ? new Image.file(
                                image,
                                fit: BoxFit.cover,
                              )
                            : new Image.asset("images/back.jpg",
                                fit: BoxFit.cover),
                      ],
                    ),
                  ),
                ),
                new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
                            child: Text("Albums".toUpperCase(),style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.w500,fontFamily: "Raleway",letterSpacing: 2.0),maxLines: 1),
                          ),
                          Container(
                            //aspectRatio: 16/15,
                            height: 210.0,
                            child: new ListView.builder(
                              itemCount: albums.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) => Padding(
                                    padding: const EdgeInsets.only(bottom: 35.0),
                                    child: new Card(
                                      elevation: 15.0,
                                      child: new InkResponse(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              child: getImage(albums[i]) != null
                                                  ? new Image.file(
                                                      getImage(albums[i]),
                                                      height: 120.0,
                                                      width: 180.0,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : new Image.asset(
                                                      "images/back.jpg",
                                                      height: 120.0,
                                                      width: 180.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            SizedBox(
                                              width: 180.0,
                                              child: Padding(
                                                // padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                                                padding: EdgeInsets.fromLTRB(10.0, 8.0, 0.0, 0.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      albums[i].album.toUpperCase(),
                                                      style: new TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black.withOpacity(0.70)),
                                                      maxLines: 1,
                                                    ),
                            
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator
                                              .of(context)
                                              .push(new MaterialPageRoute(builder: (context) {
                                            return new CardDetail(widget.db, albums[i]);
                                          }));
                                        },
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 0.0, bottom: 10.0),
                            child: Text("Songs".toUpperCase(),style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.w500,fontFamily: "Raleway",letterSpacing: 2.0),maxLines: 1),
                          ),

                        ],
                      )
                     
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
                            leading: new Icon(Icons.keyboard_arrow_right,size: 25.0,),
                            title: new Text(songs[i].title,
                                maxLines: 1, style: new TextStyle(fontSize: 15.0),overflow: TextOverflow.fade,),
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
