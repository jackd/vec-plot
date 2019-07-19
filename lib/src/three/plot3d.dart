part of vec_plot.three;

LineBasicMaterial _lineMaterial({Color color, bool useVertexColors: false}) {
  var params = LineBasicMaterialParameters();
  if (color != null) {
    params.color = color;
  } else if (useVertexColors) {
    params.vertexColors = VertexColors;
  }
  return new LineBasicMaterial(params);
}

Geometry _lineGeometry(Iterable<Vector3> vertices, [Iterable<Color> colors]) {
  var geometry = new Geometry()..vertices.addAll(vertices);
  if (colors != null) {
    geometry.colors.addAll(colors);
    geometry.colorsNeedUpdate = true;
  }
  return geometry;
}

class Plot3DBase extends Object
    with
        _Object3DWrapperMixin<Line>,
        _GeometryWrapper<Geometry>,
        _MaterialWrapper<LineBasicMaterial> {
  final Line _object;
  final Geometry _geometry;
  final LineBasicMaterial _material;

  Plot3DBase._create(this._material, this._geometry)
      : _object = Line(_geometry, _material, null);
}

class Plot3D extends Plot3DBase {
  void set vertices(Iterable<Vector3> vertices) {
    _vertices = vertices.toList();
    _geometry.verticesNeedUpdate = true;
  }

  Plot3D._create(LineBasicMaterial material, Geometry geometry)
      : super._create(material, geometry);

  factory Plot3D(Iterable<Vector3> vertices,
      {Color color, Iterable<Color> colors}) {
    var material = _lineMaterial(color: color, useVertexColors: colors != null);
    var geometry = _lineGeometry(vertices, colors);
    return Plot3D._create(material, geometry);
  }
}

class FPlot3D extends Plot3DBase {
  XyzToColor _colorF;
  XyzToColor get colorF => _colorF;
  void set colorF(XyzToColor f) {
    _colorF = f;
    _updateColors();
  }

  FPlot3D._create(this.n, LineBasicMaterial material, Geometry geometry,
      this._vertexF, this._colorF)
      : super._create(material, geometry);

  factory FPlot3D(RToXyz vertexF,
      {int n = 101, Color colorF(Vector3 v), Color color}) {
    if (color != null && colorF != null) {
      throw new ArgumentError('Cannot supply both colorF and color.');
    }
    var vertices = linspace(0, 1, n).map(vertexF).toList();

    var geometry =
        _lineGeometry(vertices, colorF == null ? null : vertices.map(colorF));
    var material = _lineMaterial(color: color, useVertexColors: colorF != null);
    return FPlot3D._create(n, material, geometry, vertexF, colorF);
  }

  RToXyz _vertexF;
  RToXyz get vertexF => _vertexF;
  final int n;
  Iterable<double> get ts => linspace(0.0, 1.0, n);
  void set vertexF(RToXyz f) {
    if (f == null) {
      throw new ArgumentError('Cannot set vertexF to null');
    }
    _vertexF = f;
    _updateVertices();
  }

  void _updateVertices() {
    _vertices = ts.map(_vertexF).toList();
    _geometry.verticesNeedUpdate = true;
    _updateColors();
  }

  void _updateColors() {
    if (_colorF != null) {
      for (var pair
          in zip<Vector3, Color>(_geometry.vertices, _geometry.colors)) {
        pair.b.copy(_colorF(pair.a));
      }
      _geometry.colorsNeedUpdate = true;
    }
  }

  Color get color => _material.color;
}
