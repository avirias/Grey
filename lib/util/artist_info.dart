//import 'dart:convert';
//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:musicplayer/pages/artist_detail.dart';
//import 'package:musicplayer/util/constants.dart';
//
//class GetArtistDetail extends StatefulWidget {
//  final String artist;
//  final int mode;
//
//  /// mode = 0 for artist image
//  /// mode = 1 similar artist details
//  /// mode = 2 bio
//  GetArtistDetail({this.artist, this.mode = 0});
//
//  @override
//  _GetArtistDetailState createState() => _GetArtistDetailState();
//}
//
//class _GetArtistDetailState extends State<GetArtistDetail> {
//  @override
//  void initState() {
//    super.initState();
//  }
//
//
//
//  showArtistPage(artistX) {
//    if (artists != null)
//      artists.forEach((artist) {
//        if (artist.artist == artistX)
//          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//            return ArtistCard(widget.artist);
//          }));
//        else
//          return;
//      });
//  }
//
//  Widget _similarArtist() {
//    return artist.artist.image != null
//        ? Column(
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Padding(
//                padding:
//                    const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10.0),
//                child: Text(
//                  "Similar artists".toUpperCase(),
//                  style: TextStyle(
//                      fontSize: 17.0,
//                      fontWeight: FontWeight.w600,
//                      letterSpacing: 1.8),
//                  maxLines: 1,
//                  overflow: TextOverflow.ellipsis,
//                ),
//              ),
//              Container(
//                color: Colors.white,
//                height: 210.0,
//                child: ListView.builder(
//                  scrollDirection: Axis.horizontal,
//                  itemCount: artist.artist.similar.artist.length,
//                  itemBuilder: (context, i) {
//                    return Padding(
//                      padding: EdgeInsets.only(bottom: 30.0),
//                      child: InkWell(
//                        onTap: showArtistPage(
//                            artist.artist.similar.artist.toList()[i].name),
//                        child: Card(
//                          elevation: 15.0,
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Image.network(
//                                  artist.artist.similar.artist
//                                      .toList()[i]
//                                      .image
//                                      .toList()[3]
//                                      .text,
//                                  height: 125.0,
//                                  width: 180.0,
//                                  fit: BoxFit.cover),
//                              SizedBox(
//                                width: 180.0,
//                                child: Padding(
//                                  padding: EdgeInsets.only(
//                                      top: 10.0, left: 4.0, right: 4.0),
//                                  child: Center(
//                                    child: Text(
//                                      artist.artist.similar.artist
//                                          .toList()[i]
//                                          .name
//                                          .toUpperCase(),
//                                      textAlign: TextAlign.left,
//                                      overflow: TextOverflow.ellipsis,
//                                      style: TextStyle(
//                                          fontSize: 13.5,
//                                          fontWeight: FontWeight.w500,
//                                          color:
//                                              Colors.black.withOpacity(0.70)),
//                                      maxLines: 1,
//                                    ),
//                                  ),
//                                ),
//                              )
//                            ],
//                          ),
//                        ),
//                      ),
//                    );
//                  },
//                ),
//              ),
//            ],
//          )
//        : Container(
//            height: 0.0,
//            width: 0.0,
//          );
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//  }
//
//  Widget returnBio() {
//    summary = artist.artist.bio.summary;
//    return ListView(children: <Widget>[
//      Center(
//          child: Text(
//        'Bio',
//        style: TextStyle(color: Colors.black, fontSize: 27.0),
//      )),
//      Text(summary, style: TextStyle(color: Colors.black, fontSize: 20.0))
//    ]);
//  }
//
//  Widget returnArtistImage() {
//    if (albumArt == null)
//      return Image.asset(
//        "images/artist.jpg",
//        fit: BoxFit.cover,
//      );
//    return artist != null
//        ? artist.artist.image != null
//            ? Image.network(
//                artist.artist.image.toList()[3].text,
//                fit: BoxFit.cover,
//              )
//            : albumArt != null
//                ? Image.file(
//                    albumArt,
//                    fit: BoxFit.cover,
//                  )
//                : Image.asset(
//                    "images/artist.jpg",
//                    fit: BoxFit.cover,
//                  )
//        : Image.file(
//            albumArt,
//            fit: BoxFit.cover,
//          );
//  }
//
//  decide(ArtistInformation artistInformation) {
//    switch (widget.mode) {
//      case 0:
//        return returnArtistImage();
//        break;
//      case 1:
//        return artist != null ? _similarArtist() : Container();
//        break;
//      case 2:
//        return artist != null ? returnBio() : Container();
//        break;
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return decide();
//  }
//}
//
