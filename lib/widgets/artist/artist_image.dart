import 'package:flutter/material.dart';
import 'package:musicplayer/model/artist_information.dart' as a;
import 'package:musicplayer/repository/repository.dart';



class ArtistImage extends StatefulWidget {

  final String artist;

  ArtistImage({this.artist});

  @override
  _ArtistImageState createState() => _ArtistImageState();
}

class _ArtistImageState extends State<ArtistImage> {
  GreyRepository _greyRepository;

  @override
  void initState() {
    super.initState();
    _greyRepository = GreyRepository();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _greyRepository.fetchArtistInfo(artist: widget.artist),
      builder: (context, AsyncSnapshot<a.ArtistInformation> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Image.asset(
              "images/artist.jpg",
              fit: BoxFit.cover,
            );
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            return snapshot.hasError
                ? Image.asset(
                    "images/back.jpg",
                    fit: BoxFit.cover,
                  )
                : _artistImage(snapshot.data);
        }
        return Text('end');
      },
    );
  }

  _artistImage(a.ArtistInformation artist) {
    print('Here');
    return Image.network(
      artist.artist.image.elementAt(3).text,
      fit: BoxFit.cover,
    );
  }
}
