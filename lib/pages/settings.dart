import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _settingState();
  }
}

class _settingState extends State<Settings> {
  var isloading = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: new Container(
        child: Column(
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.build),
              title: new Text("Rebuild database"),
              onTap: () async {
                setState(() {
                  isloading=true;
                });
                var db = new DatabaseClient();
                await db.create();
                var songs;
                try {
                  songs = await MusicFinder.allSongs();
                } catch (e) {
                  print("failed to get songs");
                }
                List<Song> list = new List.from(songs);
                for (Song song in list) db.upsertSOng(song);
                setState(() {
                  isloading = false;
                });
              },
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.info),
              title: new Text("About"),
              onTap: () {
              },
            ),
            new Divider(),
            new Container(child: isloading? new Center(
                  child: new Column(
                    children: <Widget>[
                      new CircularProgressIndicator(),
                      new Text("Loading Songs"),
                    ],
                  ),
    ):new Container()),
          ],
        ),
      ),
    );
  }
}
