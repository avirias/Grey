import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicplayer/pages/album_detail.dart';
import 'package:musicplayer/util/image_utility.dart';

class Albums extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  bool isLoading = true;
  FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<AlbumInfo> albums;

  @override
  initState() {
    super.initState();
    initAlbum();
  }

  void initAlbum() async {
    albums = await audioQuery.getAlbums();

    /// Removing WhatsApp audio
    albums.removeWhere((f) => f.title == 'WhatsApp Audio');
    setState(() {
      isLoading = false;
    });
  }

  List<Card> _buildGridCards(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return albums.map((album) {
      return Card(
        color: Colors.transparent,
        elevation: 8.0,
        child: new InkResponse(
          onTap: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new AlbumDetail(album);
            }));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Stack(
              children: <Widget>[
                Hero(tag: album.title, child: GetImage.byAlbum(album: album)),
                Positioned(
                  bottom: 0.0,
                  child: Container(
                    width: orientation == Orientation.portrait
                        ? (MediaQuery.of(context).size.width - 26.0) / 2
                        : (MediaQuery.of(context).size.width - 26.0) / 4,
                    color: Colors.white.withOpacity(0.88),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                        Padding(
                          padding: const EdgeInsets.only(left: 7.0, right: 7.0),
                          child: Text(
                            album.title,
                            style: new TextStyle(
                                fontSize: 15.5,
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Padding(
                            padding: EdgeInsets.only(left: 7.0, right: 7.0),
                            child: Text(
                              album.artist,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black.withOpacity(0.75),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 4.0))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Container(
        child: isLoading
            ? new Center(
                child: new CircularProgressIndicator(),
              )
            : Scrollbar(
                child: new GridView.count(
                  crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                  children: _buildGridCards(context),
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  childAspectRatio: 8.0 / 9.5,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 18.0,
                ),
              ));
  }
}
