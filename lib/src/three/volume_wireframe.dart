part of vec_plot.three;

class VolumeWireframe extends Object with MultiPlotObjectMixin<MultiMesh> {
  // List<MultiMesh> get _plots => [_yz, _xz, _xy];
  List<MultiMesh> get _plots => [_yz, _xy];

  final MultiMesh _yz;
  // final MultiMesh _xz;
  final MultiMesh _xy;

  XyzToXyz _xyzToXyz;
  XyzToXyz get xyzToXyz => _xyzToXyz;
  void set xyzToXyz(XyzToXyz xyzToXyz) {
    _xyzToXyz = xyzToXyz;
    _updatePlots();
  }

  void _updatePlots() {
    _yz.xyzToXyz = (v) => xyzToXyz(Vector3(v.z, v.y, v.x));
    // _xz.xyzToXyz = (v) => xyzToXyz(Vector3(v.x, v.z, v.y));
    _xy.xyzToXyz = xyzToXyz;
  }

  VolumeWireframe(XyzToXyz xyzToXyz, {int nx=11, int ny=11, int nz=11, XyzToColor colors}):
    _yz = MultiMesh(null, nx: nz, ny: ny, nz: nx, colors: colors),
    // _xz = MultiMesh(null, nx: nx, ny: nz, nz: ny, colors: colors),
    _xy = MultiMesh(null, nx: nx, ny: ny, nz: nz, colors: colors) {
    if (xyzToXyz != null) {
      this.xyzToXyz = xyzToXyz;
    }
    // _yz.visible = false;
    // _xy.visible = false;
  }
}
