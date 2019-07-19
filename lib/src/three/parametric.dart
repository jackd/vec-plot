part of vec_plot.three;

MeshBasicMaterial _buildMaterial(Texture texture, int nu, int nv,
        {bool wireframe: false,
        bool transparent: true,
        int side,
        int vertexColors}) =>
    MeshBasicMaterial()
      ..map = texture
      ..vertexColors = vertexColors ?? VertexColors
      ..transparent = transparent
      ..wireframe = wireframe
      ..side = side ?? DoubleSide
      ..map.repeat.set(nu-1, nv-1);

ParametricGeometry _buildGeometry(UvToXyz r, int nu, int nv) {
  Vector3 meshF(u, v, [Vector3 other]) => r(math.Point(u, v));
  return ParametricGeometry(allowInterop(meshF), nu-1, nv-1);
}

Vector3 _defaultR(Point uv) => Vector3(uv.x, uv.y, 0.0);

Texture getTexture() {
  var canvas = new CanvasElement();
  canvas
    ..width = 64
    ..height = 64;

  // var context = canvas.getContext( '2d' );
  var context = canvas.context2D;
  var gradient = context.createRadialGradient(
      canvas.width / 2,
      canvas.height / 2,
      0,
      canvas.width / 2,
      canvas.height / 2,
      canvas.width / 2);
  gradient.addColorStop(0.1, 'rgba(210,210,210,1)');
  gradient.addColorStop(1, 'rgba(255,255,255,1)');

  context.fillStyle = gradient;
  context.fillRect(0, 0, canvas.width, canvas.height);

  var texture = new CanvasTexture(canvas);
  return texture;
}

Texture _buildTexture() {
  var wireTexture = getTexture();
  wireTexture.wrapS = wireTexture.wrapT = RepeatWrapping;
  wireTexture.repeat.set(40, 40);
  return wireTexture;
}

class ParametricPlot extends Object
    with
        _Object3DWrapperMixin<Mesh>,
        _GeometryWrapper<ParametricGeometry>,
        _MaterialWrapper<MeshBasicMaterial> {
  final Mesh _object;
  final ParametricGeometry _geometry;
  final MeshBasicMaterial _material;
  bool get wireframe => _material.wireframe;
  void set wireframe(bool wireframe) {
    _material.wireframe = wireframe;
  }

  ParametricPlot._create(this._object, this._geometry, this._material);

  factory ParametricPlot(UvToXyz r,
      {int nu = 21,
      int nv = 21,
      XyzToColor colors,
      bool wireframe: false,
      int side}) {
    var geometry = _buildGeometry(r ?? _defaultR, nu, nv);
    var texture = _buildTexture();
    var material = _buildMaterial(texture, nu, nv,
        wireframe: wireframe, side: side ?? DoubleSide);
    var mesh = Mesh(geometry, material);
    var plot = ParametricPlot._create(mesh, geometry, material);
    colors = colors ?? (_) => Color(0, 0, 1);
    plot.xyzToColor = colors;
    plot.updateUvs();
    return plot;
  }

  List<math.Point> _uvs;
  Iterable<math.Point> get uvs => _uvs;

  XyzToUv _xyzToUv = (xyz) => math.Point(xyz.x, xyz.y);
  XyzToUv get xyzToUv => _xyzToUv;
  void set xyzToUv(XyzToUv xyzToUv) {
    _xyzToUv = xyzToUv;
    updateUvs();
  }

  List<math.Point> updateUvs() {
    if (xyzToUv == null) {
      throw new StateError(
          'cannot calculate uvs without xyzToUv defined in constructor');
    }
    return _uvs = _vertices.map<math.Point>(_xyzToUv).toList();
  }

  UvToXyz _uvToXyz;
  UvToXyz get uvToXyz => _uvToXyz;
  void set uvToXyz(UvToXyz uvToXyz) {
    _uvToXyz = uvToXyz;
    updateVertices();
  }

  void updateVertices() {
    var n = _vertices.length;
    if (_uvs == null){
      updateUvs();
      // throw StateError('Attempted to update vertices from null uvs.');
    }
    else if (_uvs.length != n) {
      throw new StateError(
          'Expected a uv for each vertex, but got ${uvs.length} uvs and $n '
          'vertices');
    }
    for (var pair in zip(_uvs, _vertices)) {
      pair.b.copy(_uvToXyz(pair.a));
    }
    _geometry.verticesNeedUpdate = true;
  }

  void _updateVertexColors(List<Color> colors) {
    for (var face in _geometry.faces) {
      if (face.vertexColors.length == 0) {
        face.vertexColors =
            [face.a, face.b, face.c].map((j) => colors[j]).toList();
      } else {
        face
          ..vertexColors[0].copy(colors[face.a])
          ..vertexColors[1].copy(colors[face.b])
          ..vertexColors[2].copy(colors[face.c]);
      }
    }
    _geometry.colorsNeedUpdate = true;
  }

  XyzToColor _xyzToColor;
  XyzToColor get xyzToColor => _xyzToColor;
  void set xyzToColor(XyzToColor xyzToColor) {
    _xyzToColor = xyzToColor;
    updateColorsFromVertices();
  }

  void updateColorsFromVertices() {
    var colors = _vertices.map<Color>(_xyzToColor).toList();
    _updateVertexColors(colors);
  }
}
