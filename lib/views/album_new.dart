import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/card_detail.dart';
import 'package:musicplayer/util/utility.dart';
import 'dart:ui' as ui;

class AlbumNew extends StatefulWidget {
  DatabaseClient db;
  AlbumNew(this.db);
  @override
  _AlbumState createState() => _AlbumState();
}

class _AlbumState extends State<AlbumNew> {
  List<Song> albums;
  bool _isLoading;

  void initAlbum() async {
    // songs=await widget.db.fetchSongs();
    albums = await widget.db.fetchAlbum();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initAlbum();
  }

  List<Card> _buildGridCards(BuildContext context) {
    return albums.map((song) {
      return Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
        child: new InkResponse(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18 / 16,
                child: Hero(
                  tag: song.album,
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
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
              ),
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 8.0, 5.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            song.album,
                            style: new TextStyle(
                                fontSize: 15.0,
                                color: Colors.black.withOpacity(0.65),
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Center(
                            child: Text(
                              song.artist,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
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
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.blueGrey.shade800,
                  Colors.blueGrey.shade400,
                  Colors.blueGrey.shade200
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.clamp),
          ),
        ),
        BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaY: 8.0, sigmaX: 8.0),
          child: Container(
            decoration:
                BoxDecoration(color: Colors.grey.shade200.withOpacity(0.3)),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: width*0.1),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Albums",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 55.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  color: Colors.transparent,
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: _buildGridCards(context),
                    childAspectRatio: 8.0 / 9.5,
                    padding: EdgeInsets.only(left: 5.0,right: 5.0,top: width*0.22),
                    physics: BouncingScrollPhysics(),
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 17.0,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
