import 'package:flute_music_player/flute_music_player.dart';
import 'package:material_search/material_search.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/lastplay.dart';

class SearchSong extends StatefulWidget {
  DatabaseClient db;
  List<Song> songs;
  SearchSong(this.db, this.songs);
  @override
  State<StatefulWidget> createState() {
    return new _statesearch();
  }
}

class _statesearch extends State<SearchSong> {
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
   Widget build(BuildContext context) {
    return new Scaffold(
      
        body: new SafeArea(
      child: new MaterialSearchInput<String>(
        placeholder:
            'Search songs', //placeholder of the search bar text input
        results: widget.songs
            .map((song) => new MaterialSearchResult<String>(
                  value: song.title, //The value must be of type <String>
                  text: song.title, //String that will be show in the list
                  icon: Icons.music_note,
                ))
            .toList(),

        onSelect: (String selected) async {
          if (selected == null) {
            //user closed the MaterialSearch without selecting any value
            return;
          }
          widget.songs.retainWhere((song) =>
              (song.title) == selected);
          Navigator.pop(context);
          MyQueue.songs = widget.songs;
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new NowPlaying(widget.db, widget.songs, 0, 0);
          }));
        },
      ),
    ));
  }
}


