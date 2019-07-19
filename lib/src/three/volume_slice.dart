part of vec_plot.three;

class VolumeSlice extends DelegatingPlotObjectBase<ParametricPlot> {
  VolumeSlice(XyzToR f, {Colormap colormap: Colormap.jet, ParametricPlot plot})
      : _f = f,
        _colormap = colormap,
        super(plot ??
            ParametricPlot((uv) => Vector3(uv.x, uv.y, 0.0),
                colors: (xyz) => colorFromMap(colormap, f(xyz))));
  // {
  //   _plot.xyzToUv = (xyz) => math.Point(xyz.x, xyz.y);
  // }

  XyzToR _f;
  XyzToR get f => _f;
  void set f(XyzToR f) {
    _f = f;
    _updateColors();
  }

  _updateUvToXyz(UvToXyz uvToXyz) {
    _plot
      ..uvToXyz = uvToXyz
      ..updateColorsFromVertices();
  }

  num _x;
  num get x => _x;
  void set x(num x) {
    _x = x;
    _y = null;
    _z = null;
    _updateUvToXyz((uv) => Vector3(x, uv.x, uv.y));
  }

  num _y;
  num get y => _y;
  void set y(num y) {
    _x = null;
    _y = y;
    _z = null;
    _updateUvToXyz((uv) => Vector3(uv.x, y, uv.y));
  }

  num _z = 0.0;
  num get z => _z;
  void set z(num z) {
    _x = null;
    _y = null;
    _z = z;
    _updateUvToXyz((uv) => Vector3(uv.x, uv.y, z));
  }

  void _updateColors() =>
      _plot.xyzToColor = (xyz) => colorFromMap(colormap, f(xyz));

  Colormap _colormap;
  Colormap get colormap => _colormap;
  void set colormap(Colormap colormap) {
    _colormap = colormap;
    _updateColors();
  }
}
