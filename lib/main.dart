import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayer/musichome.dart';
void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent));
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        canvasColor: Colors.transparent,
        errorColor: Colors.transparent,
        fontFamily: "Google Sans"
      ),
      darkTheme: ThemeData.dark(),
      home: MusicHome(),
    );
  }
}
