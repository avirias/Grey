import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:musicplayer/model/artist_information.dart';
import 'package:musicplayer/util/constants.dart';

class GreyRepository {
  Future<ArtistInformation> fetchArtistInfo({@required String artist}) async {
    String url =
        "$baseUrl?method=artist.getinfo&artist=${artist.toLowerCase().replaceAll(" ", "+")}&api_key=$apiKey&format=json";
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);
    return ArtistInformation.fromJson(decodedJson);
  }
}
