import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/card_detail.dart';
import 'package:musicplayer/util/utility.dart';

class Album extends StatefulWidget {
  DatabaseClient db;
  Album(this.db);
  @override
  State<StatefulWidget> createState() {
    return new _stateAlbum();
  }
}

class _stateAlbum extends State<Album> {
  List<Song> songs;
  var f;
  bool isLoading = true;
  @override
  initState() {
    super.initState();
    initAlbum();
  }

  void initAlbum() async {
    // songs=await widget.db.fetchSongs();
    songs = await widget.db.fetchAlbum();
    setState(() {
      isLoading = false;
    });
  }



  List<Card> _buildGridCards(BuildContext context) {
    return songs.map((song) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 25.0),
        elevation: 10.0,
        child: new InkResponse(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18 / 16,
                child: getImage(song) != null
                      ? new Image.file(
                          getImage(song),
                          height: 120.0,
                          fit: BoxFit.fitWidth,
                        )
                      : new Image.asset(
                          "images/back.jpg",
                          height: 120.0,
                          fit: BoxFit.cover,
                        ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0),),
              Expanded(
                child: Padding(
                  // padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                  padding: EdgeInsets.fromLTRB(15.0, 8.0, 5.0, 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          song.album.toUpperCase(),
                          style: new TextStyle(fontSize: 14.0,color: Colors.black.withOpacity(0.65),fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Center(
                          child: Text(
                            song.artist.toUpperCase(),
                            maxLines: 1,
                            style: TextStyle(fontSize: 12.0, color: Colors.black54),
                          ),
                        ),
                      )
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
              return new CardDetail(widget.db, song);
            }));
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation=MediaQuery.of(context).orientation;
    return new Container(
        child: isLoading
            ? new Center(
                child: new CircularProgressIndicator(),
              )
            : Scrollbar(
                          child: new GridView.count(
                  crossAxisCount: orientation==Orientation.portrait?2:4,
                  children: _buildGridCards(context),
                  padding: EdgeInsets.all(5.0),
                  childAspectRatio: 8.0 / 10.0,
                ),
            )
    );
  }
}
