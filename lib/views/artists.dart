import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/artistcard.dart';
import 'package:musicplayer/pages/card_detail.dart';
import 'package:musicplayer/util/artistInfo.dart';

class Artists extends StatefulWidget {
  DatabaseClient db;
  Artists(this.db);
  @override
  State<StatefulWidget> createState() {
    return new _stateArtist();
  }
}

class _stateArtist extends State<Artists> {
  List<Song> songs;
  var f;
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    initArtists();
  }

  void initArtists() async {
    songs = await widget.db.fetchArtist();
    setState(() {
      isLoading = false;
    });
  }

  dynamic getImage(Song song) {
    return song.albumArt == null
        ? null
        : new File.fromUri(Uri.parse(song.albumArt));
  }

  List<Card> _buildGridCards(BuildContext context) {
    return songs.map((song) {
      return Card(
        color: Colors.transparent,
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 18.0),
        elevation: 10.0,
        child: new InkWell(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 18 / 16,
                  child: Hero(
                    tag: song.artist,
                    child: GetArtistDetail(artist: song.artist,artistSong: song,)
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                        child: Text(
                          song.artist.toUpperCase(),
                          style: new TextStyle(fontFamily: "Quicksand",fontSize: 13.0,fontWeight: FontWeight.w600,letterSpacing: 2.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator
                .of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new ArtistCard(widget.db, song);
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
            ? new Center(child: new CircularProgressIndicator())
            : Scrollbar(
                  child: new GridView.count(
                    physics: BouncingScrollPhysics(),
                  crossAxisCount:orientation==Orientation.portrait? 2:4,
                  children: _buildGridCards(context),
                  padding: EdgeInsets.all(10.0),
                  childAspectRatio: 8.0 / 9.5,
                ),
            ));
  }
}
