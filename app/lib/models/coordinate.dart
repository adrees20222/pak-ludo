class Coordinate {
  final int x;
  final int y;

  const Coordinate(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinate &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() => '($x, $y)';

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(json['x'] as int, json['y'] as int);
  }
}
