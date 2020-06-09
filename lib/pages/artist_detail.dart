import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/music_player.dart';
import 'package:musicplayer/model/artist_info.dart';
import 'package:musicplayer/pages/album_detail.dart';
import 'package:musicplayer/pages/now_playing.dart';
import 'package:musicplayer/repository/repository.dart';
import 'package:musicplayer/util/image_utility.dart';
import 'package:musicplayer/util/queue_generator.dart';
import 'package:musicplayer/util/theme.dart';
import 'package:musicplayer/widgets/artist/artist_image.dart';
import 'package:musicplayer/widgets/extensions/music_metadata.dart';
import 'package:musicplayer/widgets/player/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtistDetail extends StatefulWidget {
  final String artistName;

  ArtistDetail(this.artistName);

  @override
  State<StatefulWidget> createState() => _StateCardDetail();
}

class _StateCardDetail extends State<ArtistDetail> {
  List<SongInfo> songs;
  List<AlbumInfo> albums;
  int artistId;

  FlutterAudioQuery audioQuery = FlutterAudioQuery();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initInformation();
  }

  void initInformation() async {
    artistId = await SharedPreferences.getInstance().then((res) {
      return res.getInt(widget.artistName);
    });
    songs = await audioQuery.getSongsFromArtist(artist: widget.artistName);
    albums = await audioQuery.getAlbums();
    albums.retainWhere((f) => f.artist == widget.artistName);
    setState(() {
      isLoading = false;
    });
  }

//  showBio() {
//    showDialog(
//        context: context,
//        child: Material(
//            child: Container(
//                color: Colors.white,
//                margin: EdgeInsets.all(80.0),
//                child: ArtistBio(
//                  artist: widget.artistName,
//                ))));
//  }

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
                    title: Text(
                      widget.artistName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    background: new Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Hero(
                            tag: widget.artistName,
                            child: ArtistImageFuture(
                              artist: widget.artistName,
                            )),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                    Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //TODO: Similar artists
                        ArtistDetailNetwork(
                          artistId: artistId,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 15.0, bottom: 10.0),
                          child: Text(
                            "Avialable Albums".toUpperCase(),
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.8),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        /// Albums ListView
                        Container(
                          height: 190.0,
                          child: new ListView.builder(
                            itemCount: albums.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: new Card(
                                elevation: 12.0,
                                child: new InkResponse(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          width: 180,
                                          child: Hero(
                                              tag: albums[i].title,
                                              child: GetImage.byAlbum(
                                                  fit: BoxFit.cover,
                                                  album: albums[i])),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(
                                            width: 180,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10.0, 8.0, 5.0, 8.0),
                                              child: Text(
                                                albums[i].title.toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                                maxLines: 1,
                                              ),
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
                            leading: Icon(Icons.music_note),
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
                                  style: new TextStyle(color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            trailing: new Text(
                              new Duration(
                                      milliseconds:
                                          int.parse(songs[i].duration))
                                  .toString()
                                  .split('.')
                                  .first
                                  .substring(3, 7),
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.black54),
                              softWrap: true,
                            ),
                            onTap: () {
                              PlayQueue queue =
                                  QueueGenerate().fromSongs(songs: songs);
                              PlayerWidget.player(context).playWithQueue(queue,
                                  metadata: songs[i].toMusic());
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) => new NowPlaying()));
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
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => new NowPlaying()));
        },
        child: new Icon(CupertinoIcons.shuffle_thick),
        backgroundColor: Colors.white,
        foregroundColor: accentColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ArtistDetailNetwork extends StatefulWidget {
  final int artistId;

  const ArtistDetailNetwork({Key key, this.artistId}) : super(key: key);

  @override
  _ArtistDetailNetworkState createState() => _ArtistDetailNetworkState();
}

class _ArtistDetailNetworkState extends State<ArtistDetailNetwork> {
  Artist artist;
  bool _isLoading = true;
  GreyRepository _greyRepository;

  @override
  void initState() {
    super.initState();
    _greyRepository = GreyRepository();
    _greyRepository.getArtistDetail(artistId: widget.artistId).then((val) {
      artist = val;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Container()
        : Container(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
                child: Text(
                  "Similar artists".toUpperCase(),
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.8),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: artist.similarArtist.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: Card(
                        elevation: 15.0,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: 180,
                              child: ArtistImageFuture(
                                artist: artist.similarArtist.elementAt(i).name,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: 180.0,
                                color: Colors.white.withOpacity(0.7),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0,
                                      left: 4.0,
                                      right: 4.0,
                                      bottom: 10),
                                  child: Center(
                                    child: Text(
                                      artist.similarArtist
                                          .elementAt(i)
                                          .name
                                          .toUpperCase(),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
                child: Text(
                  "albums".toUpperCase(),
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.8),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: artist.albums.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: Card(
                        elevation: 15.0,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: 180,
                              child: Image.network(
                                artist.albums.elementAt(i).imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: 180.0,
                                color: Colors.white.withOpacity(0.7),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0,
                                      left: 4.0,
                                      right: 4.0,
                                      bottom: 10),
                                  child: Center(
                                    child: Text(
                                      artist.albums
                                          .elementAt(i)
                                          .name
                                          .toUpperCase(),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ));
  }
}
