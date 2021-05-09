import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class ImageScannerAnimation extends AnimatedWidget {
  final bool stopped;
  final double width;
  final double height;

  ImageScannerAnimation(this.stopped, this.width, this.height, {Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    final scorePosition = (animation.value * 280) + 260;

    Color color1 = Color(0x5532CD32);
    Color color2 = Color(0x0032CD32);

    if (animation.status == AnimationStatus.reverse) {
      color1 = Color(0x0032CD32);
      color2 = Color(0x5532CD32);
    }

    return Positioned(
        bottom: scorePosition,
        left: width * 0.15,
        child: new Opacity(
            opacity: (stopped) ? 0.0 : 1.0,
            child: Container(
              height: 50.0,
              width: width * 0.7,
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.9],
                colors: [color1, color2],
              )),
            )));
  }
}
