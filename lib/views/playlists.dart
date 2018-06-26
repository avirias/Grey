import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musicplayer/database/database_client.dart';
import 'package:musicplayer/pages/list_songs.dart';
import 'package:musicplayer/theme.dart';


class PlayList extends StatefulWidget {
  DatabaseClient db;
  PlayList(this.db);

  @override
  State<StatefulWidget> createState() {
    return new _statePlaylist();
  }
}

class _statePlaylist extends State<PlayList> {
  var mode;
  var selected;
   Orientation orientation;
  @override
  void initState() {
    // TODO: implement initState
    mode=1;
    selected=1;
    
  }
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    return new Container(
      child: orientation == Orientation.portrait ? potrait() : landscape(),
    );
  }

  Widget potrait() {
    return new ListView(
      children: <Widget>[
        new ListTile(                   
          leading: new Icon(Icons.call_received,size: 28.0,),
          title: new Text("Recently played",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500,letterSpacing: 1.0,fontFamily: "Quicksand"),),
          subtitle: new Text("Songs"),
          onTap: () {
            Navigator
                .of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new ListSongs(widget.db, 1,orientation);
            }));
          },
        ),
        new ListTile(
          leading: new Icon(Icons.insert_chart,size: 28.0,),
          title: new Text("Top tracks",style: TextStyle(fontSize: 20.0,letterSpacing: 1.0,fontFamily: "Quicksand",fontWeight: FontWeight.w500),),
          subtitle: new Text("Songs"),
          onTap: () {
            Navigator
                .of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new ListSongs(widget.db, 2,orientation);
            }));
          },
        ),
        new ListTile(
          leading: new Icon(Icons.favorite,size: 28.0,),
          title: new Text("Favourites",style: TextStyle(fontSize: 20.0,letterSpacing: 1.0,fontFamily: "Quicksand",fontWeight: FontWeight.w500),),
          subtitle: new Text("Songs"),
          onTap: () {
            Navigator
                .of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new ListSongs(widget.db, 3,orientation);
            }));
          },
        ),
      ],
    );
  }

  Widget landscape() {
    return new Row(
      children: <Widget>[
        new Container(
          width:300.0,
    child:new ListView(
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.call_received),
              title: new Text("Recently played",style: new TextStyle(color: selected==1?Colors.blue:Colors.black)),
              subtitle: new Text("songs"),
              onTap: () {
                setState(() {
                  mode=1;
                  selected=1;
                });
              },
            ),
            new ListTile(
              leading: new Icon(Icons.show_chart),
              title: new Text("Top tracks",style: new TextStyle(color: selected==2?Colors.blue:Colors.black)),
              subtitle: new Text("songs"),
              onTap: () {
               setState(() {
                 mode=2;
                 selected=2;
               });
              },
            ),
            new ListTile(
              leading: new Icon(Icons.favorite),
              title: new Text("Favourites",style: new TextStyle(color: selected==3?Colors.blue:Colors.black)),
              subtitle: new Text("Songs"),
              onTap: (){
                setState(() {
                  mode=3;
                  selected=3;
                });
              },
            ),
          ],
        ),
        ),
        new Expanded(
          child:new Container(
            child: new ListSongs(widget.db, mode,orientation),
        )
        )
      ],
    );
  }
}
