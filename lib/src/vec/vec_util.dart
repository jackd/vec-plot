part of vec_plot.vec;

Iterable<T> listIter<T extends Vector>(VectorList<T> list) sync* {
  for (var i = 0; i < list.length; ++i) {
    yield list[i];
  }
}
