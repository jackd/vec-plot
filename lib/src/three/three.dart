library vec_plot.three;

import 'dart:math' as math;
import 'dart:html';
import 'package:threejs_facade/three.dart';
import 'package:threejs_facade/controls/trackball_controls.dart';
import 'package:js/js.dart';

import 'package:vec_plot/util.dart';
import 'package:vec_plot/colormap.dart';

part 'figure.dart';
part 'helpers.dart';
part 'wrappers.dart';

// 0D
part 'sphere.dart';

// 1D
part 'scatter.dart';
part 'plot3d.dart';

// 2D
part 'parametric.dart';
part 'surf.dart';

// 3D
part 'volume_slice.dart';
part 'multi_mesh.dart';
part 'volume_wireframe.dart';

// vectors
part 'vector_field.dart';

typedef num UvToR(math.Point uv);
typedef Vector3 UvToXyz(math.Point uv);
typedef math.Point XyzToUv(Vector3 xyz);
typedef Color UvToColor(math.Point uv);
typedef Color XyzToColor(Vector3 xyz);
typedef Vector3 XyzToXyz(Vector3 xyz);
typedef num XyzToR(Vector3 xyz);
typedef Vector3 RToXyz(num t);
typedef Color RToColor(num t);

Color colorFromMap(Colormap map, num value) =>
    Color(map.red(value), map.green(value), map.blue(value));

abstract class PlotObject {
  void attach(Figure figure);
  void detach();

  bool get visible;
  void set visible(bool visible);

  void align();
}

void _align(Object3D object) {
  // object.rotation.x = math.pi / 2;
  object.rotation.x = 0;
  object.rotation.y = 0;
  object.rotation.z = 0;
}

Iterable<Point> meshUv(Iterable<num> us, Iterable<num> vs) => mesh2d(us, vs, (u, v) => Point(u, v));

Iterable<Vector3> meshXyz(
        Iterable<num> xs, Iterable<num> ys, Iterable<num> zs) =>
    mesh3d(xs, ys, zs, (x, y, z) => Vector3(x, y, z));
