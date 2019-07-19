part of vec_plot.vec;

// class Figure {
//   final three.Scene _scene;
//   final three.PerspectiveCamera _camera;
//   final three.Renderer _renderer;
//   TrackballControls _controls;
//   TrackballControls get controls => _controls;
//   int _width;
//   int _height;
//
//   Figure._create(this._scene, this._camera, this._renderer) {
//     CanvasElement canvas = _renderer.domElement;
//     _width = canvas.width;
//     _height = canvas.height;
//   }
//
//   void addTrackball() {
//     if (_controls == null) {
//       _controls = new TrackballControls(_camera, _renderer.domElement);
//     }
//   }
//
//   factory Figure(HtmlElement container,
//       {num viewAngle: 45,
//       num near: 0.1,
//       num far: 20000,
//       int height: 400,
//       int width: 400}) {
//     var scene = new three.Scene();
//     var renderer = new three.WebGLRenderer(new three.WebGLRendererParameters()
//       ..antialias = true
//       ..alpha = true);
//     var canvas = renderer.domElement;
//     container.append(canvas);
//     var aspect = width / height;
//     var camera = new three.PerspectiveCamera(viewAngle, aspect, near, far)
//       ..up = new three.Vector3(0, 0, 1)
//       ..lookAt(scene.position);
//     renderer.setSize(width, height);
//
//     var light = new three.PointLight(new three.Color(0xffffff))
//         ..position.set(0, 0, 5);
//     scene.add(light);
//     scene.add(camera);
//
//     // renderer.setClearColor(new Color(0.0, 0.0, 0.0), 1);
//     camera.position.set(4, 1, 8);
//     return Figure._create(scene, camera, renderer);
//   }
//
//   void resize(int width, int height) {
//     var changed = !(width == _width && _height == height);
//     if (changed) {
//       _width = width;
//       _height = height;
//       _renderer.setSize(width, height);
//       _camera.aspect = width / height;
//       _camera.updateProjectionMatrix();
//     }
//   }
//
//   void render() {
//     _renderer.render(_scene, _camera);
//   }
//
//   bool _animating = false;
//
//   void startAnimation() {
//     _animating = true;
//     _animate(null);
//   }
//
//   void stopAnimation() {
//     _animating = false;
//   }
//
//   void _animate(num dt) {
//     if (_animating) {
//       window.requestAnimationFrame(_animate);
//       render();
//       if (controls != null) {
//         controls.update();
//       }
//     }
//   }
//
//   // void _addObject(three.Object3D object) => _scene.add(object);
// }
