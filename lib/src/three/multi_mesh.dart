part of vec_plot.three;

class MultiMesh extends Object with MultiPlotObjectMixin<ParametricPlot> {
  final List<ParametricPlot> _plots;

  final int nx;
  final int ny;
  final int nz;

  XyzToXyz _xyzToXyz;
  XyzToXyz get xyzToXyz => _xyzToXyz;
  void set xyzToXyz(XyzToXyz xyzToXyz) {
    _xyzToXyz = xyzToXyz;
    _updatePlots();
  }

  void _updatePlots() {
    var zs = linspace(0, 1, nz);
    for (var i = 0; i < nz; ++i) {
      var z = zs[i];
      _plots[i].uvToXyz = (uv) => _xyzToXyz(Vector3(uv.x, uv.y, z));
    }
  }

  MultiMesh(XyzToXyz xyzToXyz, {
      this.nx = 11, this.ny = 11, this.nz = 11, XyzToColor colors})
      : _plots = linspace(0, 1, nz).map((z) => ParametricPlot(
            null,
            nu: nx,
            nv: ny,
            colors: colors,
            wireframe: true)).toList() {
    if (xyzToXyz != null) {
      this.xyzToXyz = xyzToXyz;
    }
  }
}
