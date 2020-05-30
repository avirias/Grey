import 'package:flutter/material.dart';
import 'package:musicplayer/model/artist_information.dart';
import 'package:musicplayer/repository/repository.dart';

class ArtistBio extends StatefulWidget {

  final String artist;

  const ArtistBio({Key key, this.artist}) : super(key: key);

  @override
  _ArtistBioState createState() => _ArtistBioState();
}

class _ArtistBioState extends State<ArtistBio> {
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
      builder: (context, AsyncSnapshot<ArtistInformation> snapshot){
        switch(snapshot.connectionState){

          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            break;
        }
        return Text('end');
      },
    );
  }
}
