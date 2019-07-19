library vec_plot.util;

import 'dart:collection';
import 'package:quiver/core.dart';

class Range<T extends num> extends IterableBase<T> {
  final T start;
  final T stop;
  final T step;
  final int length;

  T operator [](int i) =>
      i >= length ? throw RangeError.range(i, 0, length) : start + i * step;

  Range<T> sublist(int start, [int stop]) => Range(
      this.start + step * start,
      stop == null ? this.stop : this.start + step * stop,
      step,
      stop == null? length - start: stop - start);

  Range<T> skip(int count) =>
      Range(start + step * count, stop, step, length - count);

  Range<T> take(int count) =>
      Range<T>(start, start + count * step, step, length - count);

  Range(this.start, this.stop, this.step, [int length])
      : this.length = length ?? (stop - start) ~/ step;
  @override
  Iterator<T> get iterator => RangeIterator<T>(this);
}

class RangeIterator<T extends num> implements Iterator<T> {
  final Range<T> range;
  int _i = -1;
  RangeIterator(this.range);

  @override
  T get current => range.start + _i * range.step;

  bool moveNext() => ++_i < range.length;
}

Range<T> range<T extends num>(T start, T stop, T step) =>
    Range(start, stop, step);

Range<double> linspace(num start, num stop, int length) =>
    Range(start, stop, (stop - start) / (length - 1), length);

class Pair<A, B> {
  final A a;
  final B b;
  Pair(this.a, this.b);

  bool operator ==(Object other) =>
      other is Pair<A, B> && a == other.a && b == other.b;

  int get hashCode => hash2(a, b);
  List toList() => [a, b];

  String toString() => '($a, $b)';
}

T min<T extends Comparable>(T a, T b) => a.compareTo(b) < 0 ? a : b;
T max<T extends Comparable>(T a, T b) => a.compareTo(b) < 0 ? b : a;

class Zipped<A, B> extends IterableBase<Pair<A, B>> {
  final Iterable<A> _a;
  final Iterable<B> _b;

  int get length => min<int>(_a.length, _b.length);

  Zipped(this._a, this._b);
  @override
  Iterator<Pair<A, B>> get iterator =>
      ZippedIterator<A, B>(_a.iterator, _b.iterator);

  String toString() => 'Zipped($_a, $_b)';
}

class ZippedIterator<A, B> implements Iterator<Pair<A, B>> {
  final Iterator<A> _aIter;
  final Iterator<B> _bIter;

  ZippedIterator(this._aIter, this._bIter);

  bool moveNext() => _aIter.moveNext() && _bIter.moveNext();
  Pair<A, B> get current => Pair<A, B>(_aIter.current, _bIter.current);
}

Iterable<Pair<A, B>> zip<A, B>(Iterable<A> a, Iterable<B> b) =>
    Zipped<A, B>(a, b);

class Indexed<T> {
  final int index;
  final T value;
  Indexed(this.index, this.value);

  Pair<int, T> toPair() => Pair<int, T>(index, value);
  bool operator ==(Object other) =>
      other is Indexed<T> && index == other.index && value == other.value;

  int get hashCode => hash2(index, value);
  String toString() => '$index: $value';
}

class Enumerated<T> extends IterableBase<Indexed<T>> {
  final Iterable<T> _iterable;

  Enumerated(Iterable<T> iterable) : _iterable = iterable;
  @override
  Iterator<Indexed<T>> get iterator =>
      EnumeratedIterator<T>(_iterable.iterator);
}

class EnumeratedIterator<T> implements Iterator<Indexed<T>> {
  final Iterator<T> _iterator;
  int _i = -1;
  EnumeratedIterator(this._iterator);

  bool moveNext() {
    ++_i;
    return _iterator.moveNext();
  }

  Indexed<T> get current => Indexed<T>(_i, _iterator.current);
}

Enumerated<T> enumerate<T>(Iterable<T> iterable) => Enumerated<T>(iterable);

Iterable<T> mesh2d<U, V, T>(Iterable<U> us, Iterable<V> vs, T f(U u, V v)) =>
    us.expand((u) => vs.map((v) => f(u, v)));

Iterable<T> mesh3d<U, V, W, T>(
        Iterable<U> us, Iterable<V> vs, Iterable<W> ws, T f(U u, V v, W w)) =>
    us.expand((u) => mesh2d<V, W, T>(vs, ws, (v, w) => f(u, v, w)));
