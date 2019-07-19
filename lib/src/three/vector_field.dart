part of vec_plot.three;

class Arrow extends _Object3DWrapperBase<ArrowHelper> {
  Arrow._create(
      ArrowHelper helper, this._length, this._headLength, this._headWidth)
      : super(helper);

  num _length;
  num _headLength;
  num _headWidth;

  void _updateLengths() => _object.setLength(_length, _headLength, _headWidth);

  num get length => _length;
  void set length(num length) {
    _length = length;
    _updateLengths();
  }

  num get headLength => _headLength;
  void set headLength(num headLength) {
    _headLength = headLength;
    _updateLengths();
  }

  num get headWidth => _headWidth;
  void set headWidth(num headWidth) {
    _headWidth = headWidth;
    _updateLengths();
  }

  void set color(Color color) => _object.setColor(color.getHex());

  factory Arrow(Vector3 direction,
      {Vector3 origin,
      num length = 1.0,
      Color color,
      num headLength,
      num headWidth}) {
    headLength = headLength ?? 0.2 * length;
    headWidth = headWidth ?? 0.2 * length;
    origin = origin ?? Vector3(0, 0, 0);
    color = color ?? Color(1, 1, 1);
    return Arrow._create(
        ArrowHelper(
            direction, origin, length, color.getHex(), headLength, headWidth),
        length,
        headLength,
        headWidth);
  }
}

Color jetColor(num r) => colorFromMap(Colormap.jet, r);

class VectorField extends MultiPlotObjectBase<Arrow> {
  VectorField._create(List<Arrow> plots) : super(plots);

  factory VectorField(
      Iterable<Vector3> origins, Iterable<Vector3> values, num length,
      {RToColor colorFunc: jetColor, num headLength, num headWidth}) {
    Arrow getArrow(Pair<Vector3, Vector3> pair) {
      var origin = pair.a;
      var value = pair.b;
      var mag = value.length();
      var color = colorFunc(mag);
      value.multiplyScalar(1 / mag);
      return Arrow(value,
          origin: origin,
          length: length,
          color: color,
          headLength: headLength,
          headWidth: headWidth);
    }
    return VectorField._create(zip(origins, values).map(getArrow).toList());
  }
}
