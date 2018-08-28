import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AAppBar extends StatelessWidget implements PreferredSizeWidget {

  AAppBar({
    this.title
});
  final String title;
  @override
  Size get preferredSize => Size.fromHeight(120.0);

  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarIconBrightness: Brightness.light
    ));
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blueGrey.shade500,
            Colors.blueGrey.shade400,
            Colors.blueGrey.shade300,
            Colors.blueGrey.shade200,
            Colors.blueGrey.shade100,
            Colors.blueGrey.shade50,
            Colors.grey.shade100,
            Colors.grey.shade50,
            Color(0xFFFAFAFA)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
        )
      ),
      height: preferredSize.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).padding.top,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0,left: 20.0),
            child: Text(title,style: TextStyle(
              color: Colors.black54,
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,

            ),),
          )
        ],
      ),
    );
  }

}
