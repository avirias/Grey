import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:musicplayer/database/database_client.dart';

dynamic getImage(Song song) {
  return song.albumArt == null
      ? null
      : new File.fromUri(Uri.parse(song.albumArt));
}

Widget avatar(context, File f, String title) {
  return new Material(
    borderRadius: new BorderRadius.circular(30.0),
    elevation: 2.0,
    child: f != null
        ? new CircleAvatar(
            backgroundImage: new FileImage(
              f,
            ),
          )
        : new CircleAvatar(
            child: new Text(title[0].toUpperCase()),
          ),
  );
}

class Repeat {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/repeat.txt');
  }

  Future<int> read() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If we encounter an error, return 0
      return 0;
    }
  }

  Future<File> write(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class SearchSong extends SearchDelegate<String> {
  List<String> recentSearches;
  DatabaseClient db;
  List suggestionList;

  buildSuggestionList() async {
    List<Song> songs;
    List<String> artists, albums;
    if (query != null && query != '') {
      songs = await db.searchSongByTitle(query);
      artists = await db.searchArtist(query);
      albums = await db.searchAlbum(query);
    }

    songs.forEach((song) {
      suggestionList.add(song);
    });
    albums.forEach((album) {
      suggestionList.add('0$album');
    });
    suggestionList.addAll(artists);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    buildSuggestionList();

    //added 1 at start for recent Searches
    //0 for albums
    var results = query.isEmpty ? recentSearches : suggestionList;
    return Container(
      color: Colors.white,
      child: results!=null
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(results[index] is Song
                      ? Icons.music_note
                      : results[index].toString().startsWith('1')
                          ? Icons.access_time
                          : results[index].toString().startsWith('0')
                              ? Icons.album
                              : Icons.person),
                  title: Text(
                    results[index] is Song
                        ? (results[index] as Song).title +
                            ' - ' +
                            (results[index] as Song).artist
                        : results[index].toString().startsWith('1')
                            ? results[index].toString().substring(1)
                            : results[index].toString().startsWith('0')
                                ? results[index].toString().substring(1)
                                : results[index].toString(),
                  ),
                );
              },
            )
          : Container(
              color: Colors.white,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 120.0,
                  ),
                  Icon(
                    Icons.search,
                    size: 100.0,
                    color: Colors.black45,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Search songs,albums,artists',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 28.0),
                  ),
                ],
              ),
            ),
    );
  }
}
