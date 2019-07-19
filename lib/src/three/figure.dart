part of vec_plot.three;

class Figure {
  final Scene scene;
  final PerspectiveCamera camera;
  final Renderer renderer;
  TrackballControls _controls;
  TrackballControls get controls => _controls;
  int _width;
  int _height;

  Figure._create(this.scene, this.camera, this.renderer) {
    autoResize();
  }

  void autoResize() {
    var container = renderer.domElement.parent;
    resize(container.offsetWidth, container.offsetHeight);
  }

  void fullScreen() {
    resize(window.innerWidth, window.innerHeight);
  }

  void addTrackball() {
    if (_controls == null) {
      _controls = new TrackballControls(camera, renderer.domElement);
    }
  }

  factory Figure(HtmlElement container,
      {num viewAngle: 45, num near: 0.1, num far: 20000, Light light}) {
    var scene = new Scene();
    var renderer = new WebGLRenderer(new WebGLRendererParameters()
      ..antialias = true
      ..alpha = true);
    container.append(renderer.domElement);
    var width = container.offsetWidth;
    var height = container.offsetHeight;
    var aspect = width / height;
    var camera = new PerspectiveCamera(viewAngle, aspect, near, far)
      ..up = new Vector3(0, 0, 1)
      ..lookAt(scene.position);
    renderer.setSize(width, height);

    if (light == null) {
      light = new PointLight(new Color(0xffffff))
        // ..position.set(0, 250, 0)
        ..position.set(0, 0, 5);
      // light.position.set(0, 250, 0);
    }
    scene.add(light);
    scene.add(camera);

    // renderer.setClearColor(new Color(0.0, 0.0, 0.0), 1);
    camera.position.set(4, 1, 8);
    return Figure._create(scene, camera, renderer);
  }

  void resize(int width, int height) {
    var changed = !(width == _width && _height == height);
    if (changed) {
      _width = width;
      _height = height;
      camera.aspect = width / height;
      camera.updateProjectionMatrix();
      renderer.setSize(width, height);
    }
  }

  void render() {
    renderer.render(scene, camera);
  }

  bool _animating = false;

  void startAnimation() {
    _animating = true;
    _animate(null);
  }

  void stopAnimation() {
    _animating = false;
  }

  void _animate(num dt) {
    if (_animating) {
      window.requestAnimationFrame(_animate);
      render();
      if (controls != null) {
        controls.update();
      }
    }
  }

  void _addObject(Object3D object) => scene.add(object);

  Plot3D plot3d(Iterable<Vector3> vertices,
          {Color color, Iterable<Color> colors}) =>
      Plot3D(vertices, color: color, colors: colors)..attach(this);

  FPlot3D fPlot3d(RToXyz vertexF,
          {int n = 101, Color colorF(Vector3 v), Color color}) =>
      FPlot3D(vertexF, n: n, colorF: colorF, color: color)..attach(this);

  ParametricPlot surf(UvToR f, {int nu = 21, int nv = 21, XyzToColor colors}) =>
      _surf(f, nu: nu, nv: nv, colors: colors)..attach(this);

  ParametricPlot parametricPlot(UvToXyz r,
          {int nu = 21,
          int nv = 21,
          XyzToColor colors,
          bool wireframe: false}) =>
      ParametricPlot(r, nu: nu, nv: nv, colors: colors, wireframe: wireframe)
        ..attach(this);

  PlotObject axisArrows([num length = 1, num headLength, num headWidth]) =>
      _axisArrows(length, headLength, headWidth)..attach(this);

  PlotObject gridHelper(
          [num size, int divisions, Color color1, Color color2]) =>
      _gridHelper(size, divisions, color1, color2)..attach(this);
  PlotObject polarGridHelper(
          [num radius,
          int radials,
          int circles,
          int divisions,
          Color color1,
          Color color2]) =>
      _polarGridHelper(radius, radials, circles, divisions, color1, color2)
        ..attach(this);

  VolumeSlice volumeSlice(XyzToR f, {Colormap colormap: Colormap.jet}) =>
      VolumeSlice(f, colormap: colormap)..attach(this);

  VolumeWireframe volumeWireframe(XyzToXyz xyzToXyz,
          {int nx = 11, int ny = 11, int nz = 11, XyzToColor colors}) =>
      VolumeWireframe(xyzToXyz, nx: nx, ny: ny, nz: nz, colors: colors)
        ..attach(this);

  Scatter scatter(Iterable<Vector3> vertices,
          {Color color,
          Iterable<Color> colors,
          bool lights: false,
          num size: 1.0}) =>
      Scatter(vertices,
          color: color, colors: colors, lights: lights, size: size)
        ..attach(this);

  Sphere sphere(
          {num radius: 1.0,
          Vector3 position,
          int widthSegments: 8,
          int heightSegments: 3,
          Color color}) =>
      Sphere(
          radius: radius,
          position: position,
          widthSegments: widthSegments,
          heightSegments: heightSegments,
          color: color)
        ..attach(this);

  Arrow arrow(Vector3 direction,
          {Vector3 origin,
          num length = 1.0,
          Color color,
          num headLength,
          num headWidth}) =>
      Arrow(direction,
          origin: origin,
          length: length,
          color: color,
          headLength: headLength,
          headWidth: headWidth)
        ..attach(this);

  VectorField vectorField(
          Iterable<Vector3> origins, Iterable<Vector3> values, num length,
          {RToColor colorFunc: jetColor, num headLength, num headWidth}) =>
      VectorField(origins, values, length,
          colorFunc: colorFunc, headLength: headLength, headWidth: headWidth)
        ..attach(this);
}

// alias to avoid name scoping issues with Figure.
const _surf = surf;
const _axisArrows = axisArrows;
const _gridHelper = gridHelper;
const _polarGridHelper = polarGridHelper;
