import 'dart:io';
import 'dart:async';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseClient {
  Database _db;
  Song song;
  Future create() async {
    Directory path = await getApplicationDocumentsDirectory();
    String dbpath = join(path.path, "database.db");
    _db = await openDatabase(dbpath, version: 1, onCreate: this._create);
  }

  Future _create(Database db, int version) async {
    await db.execute("""
    CREATE TABLE songs(id NUMBER,title TEXT,duration NUMBER,albumArt TEXT,album TEXT,uri TEXT,artist TEXT,albumId NUMBER,isFav number NOT NULL default 0,timestamp number,count number not null default 0)
    """);
    await db.execute("""
    CREATE TABLE recents(id integer primary key autoincrement,title TEXT,duration NUMBER,albumArt TEXT,album TEXT,uri TEXT,artist TEXT,albumId NUMBER)
    """);
  }

  Future<Null> insertSongs() async {
    var songs;
    var count = Sqflite.firstIntValue(await _db
        .rawQuery("SELECT COUNT(*) FROM songs"));
    if (count != 0) {
      List<Map> results2 = await _db.query("songs", columns: Song.Columns);

      List<Song> songs3 = new List();
      results2.forEach((s) {
        Song song2 = new Song.fromMap(s);
        songs3.add(song2);
      });
      try {
        songs = await MusicFinder.allSongs();
      } catch (e) {
        print("failed to get songs");
      }
      List<Song> list = new List.from(songs);
      for (Song song in list) {
        if (song.count == null) {
          song.count = 0;
        }
        if (song.timestamp == null) {
          song.timestamp = 0;
        }
        if (song.isFav == null) {
          song.isFav = 0;
        }
        if (!songs3.contains(song)) await _db.insert("songs", song.toMap());
        print("Inserted");
      }
    }

  }

  Future<int> upsertSOng(Song song) async {
    if (song.count == null) {
      song.count = 0;
    }
    if (song.timestamp == null) {
      song.timestamp = 0;
    }
    if (song.isFav == null) {
      song.isFav = 0;
    }
    int id = 0;
    var count = Sqflite.firstIntValue(await _db
        .rawQuery("SELECT COUNT(*) FROM songs WHERE id = ?", [song.id]));
    if (count == 0) {
      print("count=" + count.toString());
      id = await _db.insert("songs", song.toMap());
    } else {
      print("count=" + count.toString());
      await _db
          .update("songs", song.toMap(), where: "id= ?", whereArgs: [song.id]);
    }
    return id;
  }

  Future<bool> alreadyLoaded() async {
    var count =
        Sqflite.firstIntValue(await _db.rawQuery("SELECT COUNT(*) FROM songs"));
    print("count=$count");
    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> noOfFavorites() async {
    int count = Sqflite.firstIntValue(
        await _db.rawQuery("SELECT COUNT(*) FROM songs where isFav = 1"));
    return count;
  }

  Future<List<Song>> fetchSongs() async {
    List<Map> results =
        await _db.query("songs", columns: Song.Columns, orderBy: "title");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<List<Song>> fetchSongsfromAlbum(int id) async {
    List<Map> results =
        await _db.rawQuery("select * from songs where albumid=$id order by count");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<List<Song>> fetchAlbum() async {
    //  List<Map> results = await _db.query("songs",
    // distinct: true,
    //columns: Song.Columns );
    List<Map> results = await _db.rawQuery(
        "select distinct albumid,album,artist ,albumArt from songs group by album order by album");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<List<Song>> fetchArtist() async {
    //  List<Map> results = await _db.query("songs",
    // distinct: true,
    //columns: Song.Columns );
    List<Map> results = await _db.rawQuery(
        "select distinct artist,album,albumArt from songs group by artist order by artist");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<List<Song>> fetchSongsByArtist(String artist) async {
    //  List<Map> results = await _db.query("songs",
    // distinct: true,
    //columns: Song.Columns );
    List<Map> results = await _db.rawQuery("select * from songs where artist='$artist' order by timestamp desc");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }
  Future<List<Song>> fetchAlbumByArtist(String artist) async{

    List<Map> results = await _db.rawQuery(
        "select distinct albumid,album,artist,albumArt from songs where artist='$artist'");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<List<Song>> fetchRandomAlbum() async {
    //  List<Map> results = await _db.query("songs",
    // distinct: true,
    //columns: Song.Columns );
    List<Map> results = await _db.rawQuery(
        "select distinct albumid,album,artist,albumArt from songs group by album order by RANDOM() limit 10");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<int> upsertSong(Song song) async {
    int id = 0;
    var count = Sqflite.firstIntValue(await _db
        .rawQuery("SELECT COUNT(*) FROM recents WHERE id = ?", [song.id]));
    if (count == 0) {
      print("count=" + count.toString());
      id = await _db.insert("recents", song.toMap());
    } else {
      print("count=" + count.toString());
      await _db.update("recents", song.toMap(),
          where: "id= ?", whereArgs: [song.id]);
    }
    return id;
  }

  Future<List<Song>> fetchRecentSong() async {
    //  List<Map> results = await _db.query("songs",
    // distinct: true,
    //columns: Song.Columns );
    List<Map> results =
        await _db.rawQuery("select * from songs order by timestamp desc");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<List<Song>> fetchTopSong() async {
    //  List<Map> results = await _db.query("songs",
    // distinct: true,
    //columns: Song.Columns );
    List<Map> results =
        await _db.rawQuery("select * from songs order by count desc limit 25");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<List<Song>> fetchTopAlbum() async {
    //  List<Map> results = await _db.query("songs",
    // distinct: true,
    //columns: Song.Columns );
    List<Map> results = await _db.rawQuery(
        "select * from songs group by album order by count desc limit 25");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<List<Song>> fetchTopArtists() async {
    //  List<Map> results = await _db.query("songs",
    // distinct: true,
    //columns: Song.Columns );
    List<Map> results = await _db.rawQuery(
        "select * from songs group by artist order by count desc limit 25");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<int> updateSong(Song song) async {
    int id = 0;
    var count = Sqflite.firstIntValue(await _db
        .rawQuery("SELECT COUNT(*) FROM songs WHERE id = ?", [song.id]));
    if (count == 0) {
      print("count=" + count.toString());
      id = await _db.insert("songs", song.toMap());
    } else {
      print("count=" + count.toString());
      await _db
          .update("songs", song.toMap(), where: "id= ?", whereArgs: [song.id]);
      // await _db.rawQuery("update songs set count =count +1 where id=${song.id}");
      print("updated");
    }

    return id;
  }

  Future<int> isfav(Song song) async {
    var c = Sqflite.firstIntValue(
        await _db.rawQuery("select isFav from songs where is=${song.id}"));
    if (c == 0) {
      print("not fav");
      //  await _db.rawQuery("update songs set isFav =1 where id=${song.id}");
      return 1;
    } else {
      print("fav");
      //await _db.rawQuery("update songs set isFav =0 where id=${song.id}");
      return 0;
    }
  }

  Future<int> favSong(Song song) async {
    var c = Sqflite.firstIntValue(
        await _db.rawQuery("select isFav from songs where id=${song.id}"));
    if (c == 0) {
      print("not fav" + c.toString());
      await _db.rawQuery("update songs set isFav =1 where id=${song.id}");
      return 1;
    } else {
      print("fav" + c.toString());
      await _db.rawQuery("update songs set isFav =0 where id=${song.id}");
      return 0;
    }
  }

  Future<Song> fetchLastSong() async {
    List<Map> results = await _db
        .rawQuery("select * from songs order by timestamp desc limit 1");
    Song song;
    results.forEach((s) {
      song = new Song.fromMap(s);
    });
    print(song.title);
    return song;
  }

  Future<List<Song>> fetchFavSong() async {
    //  List<Map> results = await _db.query("songs",
    // distinct: true,
    //columns: Song.Columns );
    List<Map> results = await _db.rawQuery("select * from songs where isFav=1");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<List<Song>> searchSong(String q) async {
    //  List<Map> results = await _db.query("songs",
    // distinct: true,
    //columns: Song.Columns );
    List<Map> results =
        await _db.rawQuery("select * from songs where title like '%$q%'");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }

  Future<List<Song>> fetchSongById(int id) async {
    List<Map> results = await _db.rawQuery("select * from songs where id=$id");
    List<Song> songs = new List();
    results.forEach((s) {
      Song song = new Song.fromMap(s);
      songs.add(song);
    });
    return songs;
  }
}
