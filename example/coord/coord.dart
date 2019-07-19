import 'dart:math';
import 'dart:html';
import 'package:vec_plot/three.dart';
import 'package:threejs_facade/three.dart';

Vector3 slerpVector(Vector3 a, Vector3 b, num t) => a.clone()
  ..multiplyScalar(1 - t)
  ..addScaledVector(b, t);

void main() {
  var container = querySelector('body');

  var figure = Figure(container)
    ..fPlot3d((t) => Vector3(cos(2 * pi * t), sin(2 * pi * t), t),
        colorF: (xyz) {
      var v = xyz.z;
      return Color(v, v, v);
    }
        // color: Color(1, 0, 0)
        )
    ..axisArrows()
    ..gridHelper(1)
    ..render()
    ..startAnimation()
    ..addTrackball();

  figure.fullScreen();
  window.onResize.listen((_) => figure.fullScreen());

  var blue = Color(0, 0, 1);
  var red = Color(1, 0, 0);
  XyzToColor blueFn = (_) => blue;
  XyzToColor redFn = (_) => red;

  Vector3 cylinder(Point uv) {
    var theta = 2 * pi * uv.x;
    var z = uv.y;
    var x = cos(theta);
    var y = sin(theta);
    return Vector3(x, y, z);
  }

  Vector3 base(Point uv) => Vector3(uv.x, uv.y, 0.0);
  figure
    ..parametricPlot(cylinder, colors: blueFn, wireframe: true)
    ..parametricPlot(base, colors: blueFn, wireframe: true);
  var plot = figure.parametricPlot(base, colors: redFn)
    ..updateUvs();
  RangeInputElement slerpInput = querySelector('#slerp');
  var slerpStream = slerpInput.onChange.map((_) => slerpInput.valueAsNumber);
  slerpStream.listen(
      (t) => plot.uvToXyz = (uv) => slerpVector(base(uv), cylinder(uv), t));
}
