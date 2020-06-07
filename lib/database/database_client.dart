//import 'dart:async';
//import 'dart:io';
//
//import 'package:flute_music_player/flute_music_player.dart';
//import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:sqflite/sqflite.dart';
//
//class DatabaseClient {
//  Database _db;
//  Song song;
//
//  Future create() async {
//    Directory path = await getApplicationDocumentsDirectory();
//    String dbPath = join(path.path, "database.db");
//    _db = await openDatabase(dbPath, version: 1, onCreate: this._create);
//  }
//
//  Future _create(Database db, int version) async {
//    await db.execute("""
//    CREATE TABLE songs(id NUMBER,title TEXT,duration NUMBER,albumArt TEXT,album TEXT,uri TEXT,artist TEXT,albumId NUMBER,isFav number NOT NULL default 0,timestamp number,count number not null default 0)
//    """);
//    await db.execute("""
//    CREATE TABLE recents(id integer primary key autoincrement,title TEXT,duration NUMBER,albumArt TEXT,album TEXT,uri TEXT,artist TEXT,albumId NUMBER)
//    """);
//  }
//
//  Future<bool> insertSongs() async {
//    var songs;
//    var count;
//    try {
//      count = Sqflite.firstIntValue(
//          await _db.rawQuery("SELECT COUNT(*) FROM songs"));
//    } catch (e) {
//      print("Can't Find songs");
//      return false;
//    }
//    if (count != 0) {
//      List<Map> results2 = await _db.query("songs", columns: Song.Columns);
//
//      List<Song> songs3 = new List();
//      results2.forEach((s) {
//        Song song2 = new Song.fromMap(s);
//        songs3.add(song2);
//      });
//      try {
//        songs = await MusicFinder.allSongs();
//      } catch (e) {
//        print("failed to get songs");
//      }
//      List<Song> list = new List.from(songs);
//      for (Song song in list) {
//        if (song.count == null) {
//          song.count = 0;
//        }
//        if (song.timestamp == null) {
//          song.timestamp = 0;
//        }
//        if (song.isFav == null) {
//          song.isFav = 0;
//        }
//        if (!songs3.contains(song)) await _db.insert("songs", song.toMap());
//        print("Inserted");
//      }
//    }
//    return true;
//  }
//
//  Future<int> songsCount() async {
//    return Sqflite.firstIntValue(
//        await _db.rawQuery("SELECT COUNT(*) FROM songs"));
//  }
//
//  Future<int> insertOrUpdateSong(Song song) async {
//    if (song.count == null) {
//      song.count = 0;
//    }
//    if (song.timestamp == null) {
//      song.timestamp = 0;
//    }
//    if (song.isFav == null) {
//      song.isFav = 0;
//    }
//    if (_db == null) await create();
//    int count = Sqflite.firstIntValue(
//        await _db.rawQuery("SELECT COUNT(*) FROM songs WHERE id = ${song.id}"));
//    if (count == 0) {
//      return await _db.insert("songs", song.toMap());
//    }
//    return await _db
//        .update("songs", song.toMap(), where: "id= ?", whereArgs: [song.id]);
//  }
//
//  Future<bool> alreadyLoaded() async {
//    var count =
//        Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM songs"));
//    if (count > 0) return true;
//    return false;
//  }
//
//  Future<int> noOfFavorites() async {
//    return Sqflite.firstIntValue(
//        await _db.rawQuery("SELECT COUNT(*) FROM songs where isFav = 1"));
//  }
//
//
//  Future<List<Song>> fetchAlbumByArtist(String artist) async {
//    List<Map> results = await _db.rawQuery(
//        "select distinct albumid,album,artist,albumArt from songs where artist='$artist'");
//    List<Song> songs = new List();
//    results.forEach((s) {
//      Song song = new Song.fromMap(s);
//      songs.add(song);
//    });
//    return songs;
//  }
//
//  Future<List<Song>> fetchRandomAlbum() async {
//    List<Map> results = await _db.rawQuery(
//        "select distinct albumid,album,artist,albumArt from songs group by album order by RANDOM() limit 10");
//    List<Song> songs = new List();
//    results.forEach((s) {
//      Song song = new Song.fromMap(s);
//      songs.add(song);
//    });
//    return songs;
//  }
//
//  Future<List<Song>> fetchRecentSong() async {
//    List<Map> results =
//        await _db.rawQuery("select * from songs order by timestamp desc");
//    List<Song> songs = new List();
//    results.forEach((s) {
//      Song song = new Song.fromMap(s);
//      songs.add(song);
//    });
//    return songs;
//  }
//
//  Future<List<Song>> fetchTopSong() async {
//    List<Map> results =
//        await _db.rawQuery("select * from songs order by count desc limit 25");
//    List<Song> songs = new List();
//    results.forEach((s) {
//      Song song = new Song.fromMap(s);
//      songs.add(song);
//    });
//    return songs;
//  }
//
//  Future<List<Song>> fetchTopAlbum() async {
//    List<Map> results = await _db.rawQuery(
//        "select * from songs group by album order by count desc limit 25");
//    List<Song> songs = new List();
//    results.forEach((s) {
//      Song song = new Song.fromMap(s);
//      songs.add(song);
//    });
//    return songs;
//  }
//
//  Future<List<Song>> fetchTopArtists() async {
//    List<Map> results = await _db.rawQuery(
//        "select * from songs group by artist order by count desc limit 25");
//    List<Song> songs = new List();
//    results.forEach((s) {
//      Song song = new Song.fromMap(s);
//      songs.add(song);
//    });
//    return songs;
//  }
//
//
//
//  Future<int> isFavorite(Song song) async {
//    var c = Sqflite.firstIntValue(
//        await _db.rawQuery("select isFav from songs where is=${song.id}"));
//    if (c == 0) {
//      print("not fav");
//      //  await _db.rawQuery("update songs set isFav =1 where id=${song.id}");
//      return 1;
//    } else {
//      print("fav");
//      //await _db.rawQuery("update songs set isFav =0 where id=${song.id}");
//      return 0;
//    }
//  }
//
//  Future<int> favoriteSongsList(Song song) async {
//    var c = Sqflite.firstIntValue(
//        await _db.rawQuery("select isFav from songs where id=${song.id}"));
//    if (c == 0) {
//      print("not fav" + c.toString());
//      await _db.rawQuery("update songs set isFav =1 where id=${song.id}");
//      return 1;
//    } else {
//      print("fav" + c.toString());
//      await _db.rawQuery("update songs set isFav =0 where id=${song.id}");
//      return 0;
//    }
//  }
//
//  Future<Song> fetchLastSong() async {
//    List<Map> results = await _db
//        .rawQuery("select * from songs order by timestamp desc limit 1");
//    Song song;
//    results.forEach((s) {
//      song = new Song.fromMap(s);
//    });
//    return song;
//  }
//
//}
