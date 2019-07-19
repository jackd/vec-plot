import 'package:test/test.dart';
import 'package:vec_plot/util.dart';

void main() {
  test('min', () {
    expect(min(3, 4.5), equals(3));
    expect(min(3, -2), equals(-2));
  });
  test('max', () {
    expect(max(3, 5.6), equals(5.6));
    expect(max(3, -2), equals(3));
  });
  test('pair', () {
    var a = 3;
    var b = 5.6;
    var pair = Pair<int, double>(a, b);
    expect(pair.a, equals(a));
    expect(pair.b, equals(b));
  });

  test('range', () {
    var a = 10;
    var b = 14;
    var step = 0.5;
    expect(range(a, b, step)[0], equals(a));
    expect(range(a, b, step)[7], equals(13.5));
    expect(range(a, b, step).length, equals(8));
  });
  test('linspace', () {
    var a = 1.3;
    var b = 15.0;
    var n = 13;
    expect(linspace(a, b, n).length, equals(n));
    expect(linspace(a, b, n)[0], equals(a));
    expect(linspace(a, b, n)[n - 1], equals(b));
  });
  test('zip', () {
    var a = [0, 1, 2, 3];
    var b = [10, 11, 12, 13, 14];
    expect(zip(a, b).length, equals(4));
    expect(zip(a, b).toList(),
        equals([Pair(0, 10), Pair(1, 11), Pair(2, 12), Pair(3, 13)]));
  });
  test('enumerate', () {
    var a = [3, 2, 1, 0];
    expect(enumerate(a).toList(),
        equals([Indexed(0, 3), Indexed(1, 2), Indexed(2, 1), Indexed(3, 0)]));
  });
}
