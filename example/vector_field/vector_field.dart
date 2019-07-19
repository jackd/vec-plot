import 'dart:math';
import 'dart:html';
import 'package:vec_plot/three.dart';
import 'package:vec_plot/util.dart';

void main() {
  var container = querySelector('body');

  var figure = Figure(container)
    // ..axisArrows()
    // ..gridHelper(2, 21)
    ..render()
    ..startAnimation()
    ..addTrackball();

  figure.fullScreen();
  window.onResize.listen((_) => figure.fullScreen());

  var nx = 8;
  var ny = 8;
  var nz = 8;

  var a = 1 / sqrt(3);

  var vectors =
      meshXyz(linspace(-a, a, nx), linspace(-a, a, ny), linspace(-a, a, nz));
  var values = vectors;
  figure.vectorField(vectors, values, 0.1);
}
