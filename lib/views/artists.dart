import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/card_detail.dart';

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

  List<Card> _buildGridCards(BuildContext context) {
    return songs.map((song) {
      return Card(
        child: new InkResponse(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 18 / 16,
                child: new Image.asset(
                  "images/artist.jpg",
                  height: 120.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4.0, 8.0, 0.0, 0.0),
                  child: Text(
                    song.artist,
                    style: new TextStyle(fontSize: 18.0),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator
                .of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new CardDetail(widget.db, song, 1);
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
                  crossAxisCount:orientation==Orientation.portrait? 2:4,
                  children: _buildGridCards(context),
                  padding: EdgeInsets.all(2.0),
                  childAspectRatio: 8.0 / 10.0,
                ),
            ));
  }
}
