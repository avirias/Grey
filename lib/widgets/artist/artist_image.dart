import 'dart:io';

import 'package:flutter/material.dart';
import 'package:musicplayer/repository/repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ArtistImageFuture extends StatefulWidget {
  final String artist;
  final int size;

  ArtistImageFuture({this.artist, this.size = 600});

  @override
  _ArtistImageFutureState createState() => _ArtistImageFutureState();
}

class _ArtistImageFutureState extends State<ArtistImageFuture> {
  GreyRepository _greyRepository;
  Image _fileImage;

  @override
  void initState() {
    super.initState();
    _greyRepository = GreyRepository();
    _fileImage = Image.asset(
      "images/artist.jpg",
      fit: BoxFit.cover,
    );
    _downloadAndGetImage();
  }

  /// Image is saved in format [breaking_benjamin.jpg]

  _downloadAndGetImage() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + "/images";
    var filePathAndName = documentDirectory.path +
        '/images/${widget.artist.toLowerCase().replaceAll(" ", "_")}.jpg';

    File(filePathAndName).exists().then((value) {
      if (value) {
        setState(() {
          _fileImage = Image.file(
            File(filePathAndName),
            fit: BoxFit.cover,
          );
        });
      } else {
        _greyRepository
            .getArtistImage(name: widget.artist, size: widget.size)
            .then((res) async {
              SharedPreferences.getInstance().then((val){
                val.setInt(widget.artist, res.id);
              });
          var response = await http.get(res.image);
          await Directory(firstPath).create(recursive: true);
          File file2 = new File(filePathAndName);
          file2.writeAsBytesSync(response.bodyBytes);
          setState(() {
            _fileImage = Image.file(
              file2,
              fit: BoxFit.cover,
            );
          });
        }).catchError((err) {
          _fileImage = Image.asset(
            "images/back.jpg",
            fit: BoxFit.cover,
          );
        });
      }
    }).catchError((err) {
      print(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return _fileImage;
  }
}
