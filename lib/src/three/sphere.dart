part of vec_plot.three;

class Sphere extends Object
    with
        _Object3DWrapperMixin<Mesh>,
        _GeometryWrapper<SphereGeometry>,
        _MaterialWrapper<MeshBasicMaterial> {
  final Mesh _object;
  final SphereGeometry _geometry;
  final MeshBasicMaterial _material;

  Sphere._create(this._geometry, this._material, [Vector3 position])
      : _object = Mesh(_geometry, _material) {
    if (position != null) {
      this.position = position;
    }
  }

  Vector3 get position => _object.position;
  void set position(Vector3 position) => _object.position.copy(position);

  Color get color => _material.color;
  void set color(Color color) => _material.color = color;

  factory Sphere({num radius: 1.0,
      Vector3 position,
      int widthSegments: 8,
      int heightSegments: 3,
      Color color}) {
    var geometry = SphereGeometry(radius, widthSegments, heightSegments);
    var params = MeshBasicMaterialParameters()
      ..color = color;
    var material = MeshBasicMaterial(params);
    return Sphere._create(geometry, material, position);
  }
}
