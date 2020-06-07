import 'package:flutter/material.dart';
import 'package:music_player/music_player.dart';
import 'package:musicplayer/widgets/player/player.dart';

class PlayingProgressCont extends StatefulWidget {
  @override
  _PlayingProgressContState createState() => _PlayingProgressContState();
}

class _PlayingProgressContState extends State<PlayingProgressCont> {
  bool _isUserTracking = false;
  bool _isPausedByTracking = false;
  double _userTrackingPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    final playbackState = context.listenPlayerValue.playbackState;
    final metadata = context.listenPlayerValue.metadata;
    final int position = _isUserTracking
        ? _userTrackingPosition.round()
        : playbackState.computedPosition;
    return SliderTheme(
      data: SliderThemeData(
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              position.formatAsTimeStamp(),
              style: TextStyle(
                  fontSize: 13.0,
                  color: Color(0xaa373737),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0),
            ),
            Expanded(
              child: Slider(
                activeColor: Colors.blueGrey.shade400.withOpacity(0.5),
                inactiveColor: Colors.blueGrey.shade300.withOpacity(0.3),
                value: position
                    .toDouble()
                    .clamp(0.0, metadata.duration.toDouble()),
                max: metadata.duration.toDouble(),
                onChangeStart: (value) {
                  setState(() {
                    _isUserTracking = true;
                    if (playbackState.state == PlayerState.Playing) {
                      _isPausedByTracking = true;
                      context.transportControls.pause();
                    }
                  });
                },
                onChanged: (value) {
                  _userTrackingPosition = value;
                  setState(() {});
                },
                onChangeEnd: (value) {
                  setState(() {
                    _isUserTracking = false;
                    if (_isPausedByTracking) {
                      context.transportControls.play();
                    }
                    context.transportControls.seekTo(value.toInt());
                  });
                },
              ),
            ),
            Text(
              metadata.duration.formatAsTimeStamp(),
              style: TextStyle(
                  fontSize: 13.0,
                  color: Color(0xaa373737),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0),
            ),
          ],
        ),
      ),
    );
  }
}

extension TimeStampFormatter on int {
  String formatAsTimeStamp() {
    int seconds = (this / 1000).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }
}
