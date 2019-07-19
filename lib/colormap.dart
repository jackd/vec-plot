library vec_plot.color;

abstract class Colormap {
  num red(num gray);
  num green(num gray);
  num blue(num gray);

  static const gray = const Gray._create();
  static const jet = const Jet._create();
}

class ConstantColormap implements Colormap {
  final num _red;
  final num _green;
  final num _blue;
  num red(num gray) => _red;
  num green(num gray) => _green;
  num blue(num gray) => _blue;

  const ConstantColormap(num red, num green, num blue):
    _red = red,
    _green = green,
    _blue = blue;
}

class Gray implements Colormap {
  num red(num gray) => gray;
  num green(num gray) => gray;
  num blue(num gray) => gray;

  const Gray._create();
}

class Jet implements Colormap {
  const Jet._create();
  num _interpolate(num val, num y0, num x0, num y1, num x1) {
    return (val - x0) * (y1 - y0) / (x1 - x0) + y0;
  }

  num _base(num val) {
    if (val <= -0.75)
      return 0;
    else if (val <= -0.25)
      return _interpolate(val, 0.0, -0.75, 1.0, -0.25);
    else if (val <= 0.25)
      return 1;
    else if (val <= 0.75)
      return _interpolate(val, 1.0, 0.25, 0.0, 0.75);
    else
      return 0;
  }

  num _unit(num gray) => gray*2 - 1;

  num red(num gray) => _base(_unit(gray) - 0.5);
  num green(num gray) => _base(_unit(gray));
  num blue(num gray) => _base(_unit(gray) + 0.5);
}
