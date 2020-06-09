import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:musicplayer/pages/artist_detail.dart';
import 'package:musicplayer/widgets/artist/artist_image.dart';

class Artists extends StatelessWidget {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Container(
        child: FutureBuilder(
      future: audioQuery.getArtists(),
      builder: (context, AsyncSnapshot<List<ArtistInfo>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            return Scrollbar(
                child: GridView.count(
              physics: BouncingScrollPhysics(),
              crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
              children: snapshot.data.map((artist) {
                return Card(
                  color: Colors.transparent,
                  margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 18.0),
                  elevation: 10.0,
                  child: new InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 18 / 16,
                            child: Hero(
                                tag: artist.name,
                                child: ArtistImageFuture(
                                  artist: artist.name,
                                )),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Text(
                                    artist.name,
                                    style: new TextStyle(
                                        letterSpacing: 1),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return new ArtistDetail(artist.name);
                      }));
                    },
                  ),
                );
              }).toList(),
              padding: EdgeInsets.all(10.0),
              childAspectRatio: 8.0 / 9.5,
            ));
        }
        return Text('end');
      },
    ));
  }
}

