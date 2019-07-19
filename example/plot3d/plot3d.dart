import 'dart:math';
import 'dart:html';
import 'package:vec_plot/three.dart';
import 'package:vec_plot/colormap.dart';
import 'package:threejs_facade/three.dart';

void main() {
  var container = querySelector('body');

  Vector3 f(Point uv) {
    var x = 2 * uv.x - 1;
    var y = 2 * uv.y - 1;
    var z = x * x + y * y;
    return Vector3(x - 1, y, z);
  }

  Vector3 cylinder(Point uv) {
    var theta = 2 * pi * uv.x;
    var z = uv.y;
    var x = cos(theta);
    var y = sin(theta);
    return Vector3(x + 3, y, z);
  }

  var colors = (xyz) => colorFromMap(Colormap.jet, xyz.z);
  var black = Color(0, 0, 0);
  var blue = Color(0, 0, 1);
  var blackFn = (_) => black;
  var blueFn = (_) => blue;
  var r3 = sqrt(3.0);

  var figure = Figure(container)
    ..fPlot3d((t) => Vector3(cos(2 * pi * t), sin(2 * pi * t), t),
        colorF: (xyz) {
      var v = xyz.z;
      return Color(v, v, v);
    }
        )
    ..axisArrows()
    ..surf((Point uv) => sin(uv.magnitude))
    ..parametricPlot(f, colors: colors)
    ..parametricPlot(f, colors: blackFn, wireframe: true, nu: 21, nv: 21)
    ..parametricPlot(cylinder, colors: blueFn)
    ..gridHelper(1)
    ..polarGridHelper(1)
    ..render()
    ..startAnimation()
    ..addTrackball();
  var vol = VolumeSlice(
      (xyz) => (xyz.x * xyz.x + xyz.y * xyz.y + xyz.z * xyz.z) / r3);
  vol.attach(figure);

  var xStream =
      querySelector('#x').onClick.map((_) => ((vol.x ?? 0) + 0.1) % 1);
  var yStream =
      querySelector('#y').onClick.map((_) => ((vol.y ?? 0) + 0.1) % 1);
  var zStream =
      querySelector('#z').onClick.map((_) => ((vol.z ?? 0) + 0.1) % 1);
  xStream.listen((x) => vol.x = x);
  yStream.listen((y) => vol.y = y);
  zStream.listen((z) => vol.z = z);
  // container.onResize.listen((_) => figure.autoResize());
  figure.fullScreen();
  window.onResize.listen((_) => figure.fullScreen());
  print('Done');
}
