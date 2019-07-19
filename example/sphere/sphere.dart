// import 'dart:math';
import 'dart:html';
import 'package:vec_plot/three.dart';
// import 'package:vec_plot/util.dart';
import 'package:threejs_facade/three.dart';

void main() {
  var container = querySelector('body');
  var figure = Figure(container)
    ..axisArrows()
    ..gridHelper(1)
    ..render()
    ..startAnimation()
    ..addTrackball();

  figure.fullScreen();
  window.onResize.listen((_) => figure.fullScreen());

  figure.sphere(radius: 0.04, position: Vector3(1, 1, 1), color: Color(1, 0, 0));
}
