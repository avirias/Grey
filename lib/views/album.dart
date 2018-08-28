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
    final Orientation orientation = MediaQuery.of(context).orientation;
    return songs.map((song) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        elevation: 8.0,
        child: new InkResponse(
          child: Stack(
            children: <Widget>[
              Hero(
                tag: song.album,
                child: getImage(song) != null
                    ? new Image.file(
                        getImage(song),
                        height: double.infinity,
                        fit: BoxFit.fitHeight,
                      )
                    : new Image.asset(
                        "images/back.jpg",
                        height: double.infinity,
                        fit: BoxFit.fitHeight,
                      ),
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  width: orientation == Orientation.portrait
                      ? (MediaQuery.of(context).size.width - 26.0) / 2
                      : (MediaQuery.of(context).size.width - 26.0) / 4,
                  color: Colors.white.withOpacity(0.88),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                      Padding(
                        padding: const EdgeInsets.only(left: 7.0, right: 7.0),
                        child: Text(
                          song.album,
                          style: new TextStyle(
                              fontSize: 15.5,
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Padding(
                          padding: EdgeInsets.only(left: 7.0, right: 7.0),
                          child: Text(
                            song.artist,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black.withOpacity(0.75),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0))
                    ],
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context)
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
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Container(
        child: isLoading
            ? new Center(
                child: new CircularProgressIndicator(),
              )
            : Scrollbar(
                child: new GridView.count(
                  crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                  children: _buildGridCards(context),
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  childAspectRatio: 8.0 / 9.5,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 18.0,
                ),
              ));
  }
}
