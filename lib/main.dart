import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:musicplayer/home_page.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stetho.initialize();
  runApp(new MyApp());

}


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
      home: MusicHome(),
    );
  }
}
