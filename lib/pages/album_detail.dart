
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicplayer/pages/artist_detail.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/image_utility.dart';
import 'package:musicplayer/model/queue.dart';

class AlbumDetail extends StatefulWidget {
  final AlbumInfo album;

  AlbumDetail(this.album);

  @override
  State<StatefulWidget> createState() {
    return new _StateCardDetail();
  }
}

class _StateCardDetail extends State<AlbumDetail> {

  List<SongInfo> songs;
  FlutterAudioQuery audioQuery = FlutterAudioQuery();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initAlbum();
  }


  void initAlbum() async {

    songs = await audioQuery.getSongsFromAlbum(albumId: widget.album.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.white,
        child: isLoading
            ? new Center(
                child: new CircularProgressIndicator(),
              )
            : new CustomScrollView(slivers: <Widget>[
                new SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width,
                  forceElevated: false,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: new FlexibleSpaceBar(
                    title: Text(""),
                    background: new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Hero(
                          tag: widget.album.title,
                          child: GetImage.byAlbum(album: widget.album),
                        ),
                      ],
                    ),
                  ),
                ),
                new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                    Container(
                      color: Colors.white.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 15.0, right: 10.0),
                                child: new Text(
                                  widget.album.title,
                                  style: new TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return ArtistDetail(widget.album.artist);
                                    }));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.person,
                                        size: 33.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            new Text(
                                              widget.album.artist,
                                              style: new TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                            ),
                                            songs.length != 1
                                                ? new Text(
                                                    songs.length.toString() +
                                                        " Songs",
                                                    style: TextStyle(
                                                        fontSize: 13.0),
                                                  )
                                                : new Text(
                                                    songs.length.toString() +
                                                        " Song",
                                                    style: TextStyle(
                                                        fontSize: 13.0),
                                                  )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                new SliverList(
                  delegate: new SliverChildBuilderDelegate((builder, i) {
                    return Container(
                      color: Colors.white.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Container(
                          color: Colors.white,
                          child: new ListTile(
                            leading: Hero(
                                tag: songs[i].id,
                                child: GetImage.byAlbumAllSongs(album: widget.album) ),

                            title: new Text(
                              songs[i].title,
                              maxLines: 1,
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: new Text(
                                new Duration(milliseconds: int.parse(songs[i].duration))
                                    .toString()
                                    .split('.')
                                    .first
                                    .substring(3, 7),
                                style: new TextStyle(
                                    fontSize: 12.0, color: Colors.grey)),
                            //trailing:
                            onTap: () {
                              MyQueue.songs = songs;
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      new NowPlaying(songs, i, 0)));
                            },
                          ),
                        ),
                      ),
                    );
                  }, childCount: songs.length),
                ),
              ]),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          MyQueue.songs = songs;
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) =>
                  new NowPlaying(MyQueue.songs, 0, 0)));
        },
        child: new Icon(CupertinoIcons.shuffle_thick),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey,
      ),
    );
  }
}
