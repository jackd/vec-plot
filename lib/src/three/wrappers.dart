part of vec_plot.three;

abstract class DelegatingPlotObject<P extends PlotObject>
    implements PlotObject {
  factory DelegatingPlotObject(P plot) = DelegatingPlotObjectBase<P>;
}

class DelegatingPlotObjectBase<P extends PlotObject> extends Object
    with DelegatingPlotObjectMixin<P> {
  final P _plot;
  DelegatingPlotObjectBase(this._plot);
}

abstract class DelegatingPlotObjectMixin<P extends PlotObject>
    implements DelegatingPlotObject<P> {
  P get _plot;
  void attach(Figure figure) => _plot.attach(figure);
  void detach() => _plot.detach();

  bool get visible => _plot.visible;
  void set visible(bool visible) => _plot.visible = visible;

  void align() => _plot.align();
}

abstract class MultiPlotObject<P extends PlotObject> implements PlotObject {
  Iterable<P> get _plots;
}

abstract class MultiPlotObjectMixin<P extends PlotObject>
    implements MultiPlotObject {
  bool _visible = true;
  bool get visible => _visible;
  void set visible(bool visible) {
    _visible = visible;
    _plots.forEach((p) => p.visible = visible);
  }

  void attach(Figure figure) => _plots.forEach((p) => p.attach(figure));
  void detach() => _plots.forEach((p) => p.detach());

  void align() => _plots.forEach((p) => p.align());
}

class MultiPlotObjectBase<P extends PlotObject> extends Object
    with MultiPlotObjectMixin<P> {
  final Iterable<P> _plots;
  MultiPlotObjectBase(this._plots);
}

abstract class _Object3DWrapper<O extends Object3D> implements PlotObject {
  O get _object;

  factory _Object3DWrapper(O object) = _Object3DWrapperBase<O>;
}

abstract class _Object3DWrapperMixin<O extends Object3D>
    implements _Object3DWrapper<O> {
  Figure _figure;

  void attach(Figure figure) {
    if (_figure == null) {
      figure._addObject(_object);
      _figure = figure;
    } else {
      throw StateError('Cannot attach: already attached.');
    }
  }

  void detach() {
    if (_figure == null) {
      throw StateError('Cannot detach: not attached.');
    }
    _figure.scene.remove(_object);
    _figure = null;
  }

  bool get visible => _object.visible;
  void set visible(bool visible) => _object.visible = visible;
  void align() => _align(_object);
}

class _Object3DWrapperBase<O extends Object3D> extends Object
    with _Object3DWrapperMixin<O> {
  final O _object;
  _Object3DWrapperBase(this._object);
}

class WrappedObjectGroup implements PlotObject {
  final Iterable<Object3D> _objects;
  WrappedObjectGroup(this._objects);
  Figure _figure;

  void attach(Figure figure) {
    if (_figure == null) {
      _objects.forEach(figure._addObject);
      _figure = figure;
    } else {
      throw StateError('Cannot attach: already attached.');
    }
  }

  void detach() {
    if (_figure == null) {
      throw StateError('Cannot detach: not attached.');
    }
    _objects.forEach(_figure.scene.remove);
    _figure = null;
  }

  bool _visible = true;
  bool get visible => _visible;
  void set visible(bool visible) {
    _visible = visible;
    updateVisibility();
  }

  void updateVisibility() => _objects.forEach((obj) => obj.visible = _visible);
  void align() => _objects.forEach(_align);
}

abstract class _MaterialWrapper<M extends Material> {
  M get _material;

  num get opacity => _material.opacity;
  void set opacity(num opacity) => _material.opacity = opacity;
}

abstract class _GeometryWrapper<G extends Geometry> {
  G get _geometry;
  List<Vector3> get _vertices => _geometry.vertices.cast<Vector3>();
  void set _vertices(List<Vector3> vertices) {
    _geometry.vertices = vertices;
  }
  Iterable<Color> get colors => _geometry.colors;

  // copy of vertices
  Iterable<Vector3> get vertices => _vertices.map((v) => v.clone());
}
