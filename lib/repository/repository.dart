import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:musicplayer/model/artist_image.dart';
import 'package:musicplayer/model/artist_info.dart';
import 'package:musicplayer/util/mapper/artist_mapper.dart';
import 'package:musicplayer/util/mapper/similar_artist.dart';

class GreyRepository {

  Future<ArtistImage> getArtistImage(
      {@required String name, int size = 600}) async {
    var url =
        'https://amp-api.music.apple.com/v1/catalog/us/search?term=$name&types=artists&limit=25&includeOnly=artists';
    var headers = {
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36',
      'authorization':
          'Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IldlYlBsYXlLaWQifQ.eyJpc3MiOiJBTVBXZWJQbGF5IiwiaWF0IjoxNTkxNDU4MjUxLCJleHAiOjE2MDcwMTAyNTF9.JfjAAoLNUkT1q3Rj3c_Wd0m7YPWO6KDNAtoEq67sgvXCmV_JpneYHQrhl8-HqaqYD10NLbrTPcMELNx4ER0cjw'
    };
    var response = await http.get(url, headers: headers);
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['results']['artists'] == null) {
      return Future.error('Artist Not Found');
    }
    var artist = jsonResponse['results']['artists']['data'][0];
    var id = int.parse(artist['id']);
    var u = artist['attributes']['artwork']['url'] as String;
    var image = imageUrl(url: u, size: size);
    return Future.value(ArtistImage(id: id, image: image));
  }

  Future<Artist> getArtistDetail({@required int artistId, int size = 600}) async {
    var queryParams =
        '?views=featured-release%2Cfull-albums%2csimilar-artists&extend=artistBio%2CbornOrFormed%2CeditorialArtwork%2Corigin&l=en-us';
    var baseUrl = 'https://amp-api.music.apple.com/v1/catalog/us/artists/';
    var url = baseUrl + artistId.toString() + queryParams;
    var headers = {
      'user-agent':
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.97 Safari/537.36',
      'authorization':
      'Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IldlYlBsYXlLaWQifQ.eyJpc3MiOiJBTVBXZWJQbGF5IiwiaWF0IjoxNTkxNDU4MjUxLCJleHAiOjE2MDcwMTAyNTF9.JfjAAoLNUkT1q3Rj3c_Wd0m7YPWO6KDNAtoEq67sgvXCmV_JpneYHQrhl8-HqaqYD10NLbrTPcMELNx4ER0cjw'
    };
    var response = await http.get(url, headers: headers);
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['errors'] != null) {
      return Future.error(jsonResponse['errors']['detail']);
    }

    /// Artist Detail

    var artistAttributes =
    ArtistAttributes.fromJson(jsonResponse['data'][0]['attributes']);

    /// Full albums

    var albums = <Album>[];
    (jsonResponse['data'][0]['views']['full-albums']['data']).forEach((alb) {
      var x = AlbumAttr.fromJson(alb);
      albums.add(Album(
          id: int.parse(x.id),
          contentRating: x.attributes.contentRating,
          genres: x.attributes.genreNames,
          imageUrl: imageUrl(size: size, url: x.attributes.artwork.url),
          labelName: x.attributes.recordLabel,
          name: x.attributes.name,
          releaseDate: x.attributes.releaseDate,
          trackCount: x.attributes.trackCount));
    });

    /// Similar Artists

    var similarArtists = <SimilarArtist>[];
    jsonResponse['data'][0]['views']['similar-artists']['data'].forEach((e) {
      var similarArtistModel = SimilarArtistModel.fromJson(e);
      similarArtists.add(SimilarArtist(
          name: similarArtistModel.attributes.name,
          id: int.parse(similarArtistModel.id),
          image: imageUrl(
              size: size, url: similarArtistModel.attributes.artwork.url)));
    });

    var artist = Artist(
        id: artistId,
        image: imageUrl(size: size, url: artistAttributes.artwork.url),
        name: artistAttributes.name,
        genres: artistAttributes.genreNames,
        albums: albums,
        bio: artistAttributes.artistBio,
        bornOrFormed: artistAttributes.bornOrFormed,
        similarArtist: similarArtists);

    return Future.value(artist);
  }
}

String imageUrl({int size = 600, String url}) {
  return url.replaceFirst('{w}', '$size').replaceFirst('{h}', '$size');
}
