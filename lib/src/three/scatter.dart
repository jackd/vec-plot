part of vec_plot.three;

class Scatter extends Object
    with
        _Object3DWrapperMixin<Points>,
        _GeometryWrapper<Geometry>,
        _MaterialWrapper<PointsMaterial> {
  final Points _object;
  final Geometry _geometry;
  final PointsMaterial _material;

  Scatter._create(this._geometry, this._material)
      : _object = Points(_geometry, _material);

  factory Scatter(Iterable<Vector3> vertices, {Color color, Iterable<Color> colors, bool lights: false, double size: 1.0}) {
    var geometry = Geometry();
    geometry.vertices.addAll(vertices);
    var params = PointsMaterialParameters()
      ..size = size;
    if (color != null) {
      params.color = color;
    } else if (colors != null) {
      params.vertexColors = VertexColors;
      geometry.colors.addAll(colors);
      geometry.colorsNeedUpdate = true;
    }
    var material = PointsMaterial(params);
    return Scatter._create(geometry, material);
  }
}
