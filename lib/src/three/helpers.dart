part of vec_plot.three;

PlotObject axisArrows([length = 1, headLength, headWidth]) {
  headLength = headLength ?? 0.2 * length;
  headWidth = headWidth ?? 0.2 * length;
  var origin = Vector3(0, 0, 0);
  ArrowHelper arrow(num i, num j, num k) => ArrowHelper(Vector3(i, j, k),
      origin, length, Color(i, j, k).getHex(), headLength, headWidth);

  return WrappedObjectGroup([arrow(1, 0, 0), arrow(0, 1, 0), arrow(0, 0, 1)]);
}

PlotObject gridHelper([num size, int divisions, Color color1, Color color2]) =>
    _Object3DWrapper(
        GridHelper(size, divisions, color1, color2)..rotateX(math.pi / 2));

PlotObject polarGridHelper(
        [num radius,
        int radials,
        int circles,
        int divisions,
        Color color1,
        Color color2]) =>
    _Object3DWrapper(
        PolarGridHelper(radius, radials, circles, divisions, color1, color2)..rotateX(math.pi / 2));
