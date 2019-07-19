import 'dart:math';
import 'dart:html';
import 'package:vec_plot/three.dart';
// import 'package:vec_plot/util.dart';
import 'package:threejs_facade/three.dart';

Vector3 slerpVector(Vector3 a, Vector3 b, num t) => a.clone()
  ..multiplyScalar(1 - t)
  ..addScaledVector(b, t);

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

  var blue = Color(0, 0, 1);
  XyzToColor blueFn = (_) => blue;

  Vector3 cylinder(Vector3 xyz) {
    var theta = 2 * pi * xyz.x;
    var r = xyz.y;
    var x = r*cos(theta);
    var y = r*sin(theta);
    var z = xyz.z;
    return Vector3(x, y, z-0.5);
  }
  // print(linspace(0, 1, 4).toList());
  figure.volumeWireframe(cylinder, colors: blueFn, nx: 10, ny: 6, nz: 4);
  // figure.parametricPlot(null, colors: blueFn, nu: 5, nv: 6, wireframe: true);
}
