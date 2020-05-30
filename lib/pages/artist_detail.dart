import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicplayer/pages/album_detail.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/util/image_utility.dart';
import 'package:musicplayer/model/queue.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicplayer/widgets/artist/artist_bio.dart';
import 'package:musicplayer/widgets/artist/artist_image.dart';
import 'package:musicplayer/widgets/artist/similar_artist.dart';

class ArtistDetail extends StatefulWidget {
  
  final String artistName;

  ArtistDetail(this.artistName);

  @override
  State<StatefulWidget> createState() {
    return new _StateCardDetail();
  }
}

class _StateCardDetail extends State<ArtistDetail> {
  List<SongInfo> songs;
  List<AlbumInfo> albums;

  FlutterAudioQuery audioQuery = FlutterAudioQuery();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
//    initInformation();
  }
  

  void initInformation() async {
    print(widget.artistName);
    songs = await audioQuery.getSongsFromArtist(artist: widget.artistName);
    albums = await audioQuery.getAlbumsFromArtist(artist: widget.artistName);
    setState(() {
      isLoading = false;
    });
  }

  showBio() {
    showDialog(
        context: context,
        child: Material(
            child: Container(
                color: Colors.white,
                margin: EdgeInsets.all(80.0),
                child: ArtistBio(
                  artist: widget.artistName,
                ))));
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
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.more_vert), onPressed: showBio)
                  ],
                  flexibleSpace: new FlexibleSpaceBar(
                    title: Text(
                      widget.artistName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    background: new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Hero(
                            tag: widget.artistName,
                            child: ArtistImage(
                              artist: widget.artistName,
                            )),
                      ],
                    ),
                  ),
                ),
                new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                    Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: SimilarArtists(
                            artist: widget.artistName,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 15.0, bottom: 10.0),
                          child: Text(
                            "Albums".toUpperCase(),
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.8),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          //aspectRatio: 16/15,
                          height: 205.0,
                          child: new ListView.builder(
                            itemCount: albums.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: new Card(
                                elevation: 15.0,
                                child: new InkResponse(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          child: Hero(
                                            tag: albums[i].title,
                                            child: GetImage.byAlbum(album: albums[i])
                                          ),
                                        ),
                                        SizedBox(
                                          width: 180.0,
                                          child: Padding(
                                            // padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                                            padding: EdgeInsets.fromLTRB(
                                                10.0, 8.0, 5.0, 0.0),
                                            child: Text(
                                              albums[i].title.toUpperCase(),
                                              style: new TextStyle(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black
                                                      .withOpacity(0.70)),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (context) {
                                      return new AlbumDetail(albums[i]);
                                    }));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 0.0, bottom: 10.0),
                          child: Text("Songs".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.8),
                              maxLines: 1),
                        ),
                      ],
                    )),
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
                              child: Icon(Icons.music_note),
                            ),
                            title: new Text(
                              songs[i].title,
                              maxLines: 1,
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Text(
                                  songs[i].album,
                                  style: new TextStyle(
                                      fontSize: 12.0, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            trailing: new Text(
                              new Duration(milliseconds: int.parse(songs[i].duration))
                                  .toString()
                                  .split('.')
                                  .first
                                  .substring(3, 7),
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black54),
                              softWrap: true,
                            ),
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
              builder: (context) => new NowPlaying(MyQueue.songs,
                  new Random().nextInt(songs.length), 0)));
        },
        child: new Icon(CupertinoIcons.shuffle_thick),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
