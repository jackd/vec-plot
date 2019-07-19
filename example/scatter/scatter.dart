import 'dart:math';
import 'dart:html';
import 'package:vec_plot/three.dart';
// import 'package:vec_plot/util.dart';
import 'package:threejs_facade/three.dart';

void main() {
  var container = querySelector('body');
  var figure = Figure(container)
    // ..axisArrows()
    // ..gridHelper(1)
    ..render()
    ..startAnimation()
    ..addTrackball();

  figure.fullScreen();
  window.onResize.listen((_) => figure.fullScreen());

  var n = 100000;
  var r = Random();
  Color randomColor(int i) =>
      Color(r.nextDouble(), r.nextDouble(), r.nextDouble());
  Vector3 randomVector(int i) =>
      Vector3(r.nextDouble() - 0.5, r.nextDouble() - 0.5, r.nextDouble() - 0.5);

  figure.scatter(Iterable.generate(n, randomVector),
      size: 0.02, lights: true, colors: Iterable.generate(n, randomColor));
  // figure.parametricPlot(null, colors: blueFn, nu: 5, nv: 6, wireframe: true);
}
