import 'dart:io';

import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/artistcard.dart';
import 'package:musicplayer/util/artistInfo.dart';

class Artists extends StatefulWidget {
  final DatabaseClient db;

  Artists(this.db);

  @override
  State<StatefulWidget> createState() {
    return new _StateArtist();
  }
}

class _StateArtist extends State<Artists> {
  var f;

  @override
  initState() {
    super.initState();
  }


  dynamic getImage(Song song) {
    return song.albumArt == null
        ? null
        : new File.fromUri(Uri.parse(song.albumArt));
  }

  List<Card> _buildGridCards(BuildContext context, List<Song> songs ) {
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
                      child: GetArtistDetail(
                        artist: song.artist,
                        artistSong: song,
                      )),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          song.artist.toUpperCase(),
                          style: new TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0),
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
            Navigator.of(context)
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
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Container(
        child: FutureBuilder(
          future: widget.db.fetchArtist(),
          builder: (context,AsyncSnapshot<List<Song>> snapshot){
            switch(snapshot.connectionState){

              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                return Scrollbar(
                  child: new GridView.count(
                    physics: BouncingScrollPhysics(),
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                    children: _buildGridCards(context,snapshot.data),
                    padding: EdgeInsets.all(10.0),
                    childAspectRatio: 8.0 / 9.5,
                  ),
                );
            }
            return Text('end');
          },
        ));
  }
}
