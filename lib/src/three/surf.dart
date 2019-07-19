part of vec_plot.three;

ParametricPlot surf(UvToR f,
    {int nu = 21, int nv = 21, XyzToColor colors}) {
  colors = colors ?? (xyz) => colorFromMap(Colormap.jet, xyz.z);
  return ParametricPlot(
      (uv) => Vector3(uv.x, uv.y, f(uv)), nu: nu, nv: nv, colors: colors);
}
