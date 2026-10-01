import '../models/coordinate.dart';
import '../models/player_color.dart';

class PathData {
  // 52-tile shared outer circuit track
  static const List<Coordinate> mainCircuit = [
    Coordinate(1, 6),  // 0: Red Start
    Coordinate(2, 6),  // 1
    Coordinate(3, 6),  // 2
    Coordinate(4, 6),  // 3
    Coordinate(5, 6),  // 4
    Coordinate(6, 5),  // 5
    Coordinate(6, 4),  // 6
    Coordinate(6, 3),  // 7
    Coordinate(6, 2),  // 8: Star
    Coordinate(6, 1),  // 9
    Coordinate(6, 0),  // 10
    Coordinate(7, 0),  // 11
    Coordinate(8, 0),  // 12
    Coordinate(8, 1),  // 13: Green Start
    Coordinate(8, 2),  // 14
    Coordinate(8, 3),  // 15
    Coordinate(8, 4),  // 16
    Coordinate(8, 5),  // 17
    Coordinate(9, 6),  // 18
    Coordinate(10, 6), // 19
    Coordinate(11, 6), // 20
    Coordinate(12, 6), // 21: Star
    Coordinate(13, 6), // 22
    Coordinate(14, 6), // 23
    Coordinate(14, 7), // 24
    Coordinate(14, 8), // 25
    Coordinate(13, 8), // 26: Yellow Start
    Coordinate(12, 8), // 27
    Coordinate(11, 8), // 28
    Coordinate(10, 8), // 29
    Coordinate(9, 8),  // 30
    Coordinate(8, 9),  // 31
    Coordinate(8, 10), // 32
    Coordinate(8, 11), // 33
    Coordinate(8, 12), // 34: Star
    Coordinate(8, 13), // 35
    Coordinate(8, 14), // 36
    Coordinate(7, 14), // 37
    Coordinate(6, 14), // 38
    Coordinate(6, 13), // 39: Blue Start
    Coordinate(6, 12), // 40
    Coordinate(6, 11), // 41
    Coordinate(6, 10), // 42
    Coordinate(6, 9),  // 43
    Coordinate(5, 8),  // 44
    Coordinate(4, 8),  // 45
    Coordinate(3, 8),  // 46
    Coordinate(2, 8),  // 47: Star
    Coordinate(1, 8),  // 48
    Coordinate(0, 8),  // 49
    Coordinate(0, 7),  // 50
    Coordinate(0, 6),  // 51
  ];

  static final Map<PlayerColor, List<Coordinate>> playerPaths = {
    PlayerColor.red: _buildPath(startIndex: 0, homeColumn: [
      const Coordinate(1, 7),
      const Coordinate(2, 7),
      const Coordinate(3, 7),
      const Coordinate(4, 7),
      const Coordinate(5, 7),
      const Coordinate(6, 7), // Home Center
    ]),
    PlayerColor.green: _buildPath(startIndex: 13, homeColumn: [
      const Coordinate(7, 1),
      const Coordinate(7, 2),
      const Coordinate(7, 3),
      const Coordinate(7, 4),
      const Coordinate(7, 5),
      const Coordinate(7, 6), // Home Center
    ]),
    PlayerColor.yellow: _buildPath(startIndex: 26, homeColumn: [
      const Coordinate(13, 7),
      const Coordinate(12, 7),
      const Coordinate(11, 7),
      const Coordinate(10, 7),
      const Coordinate(9, 7),
      const Coordinate(8, 7), // Home Center
    ]),
    PlayerColor.blue: _buildPath(startIndex: 39, homeColumn: [
      const Coordinate(7, 13),
      const Coordinate(7, 12),
      const Coordinate(7, 11),
      const Coordinate(7, 10),
      const Coordinate(7, 9),
      const Coordinate(7, 8), // Home Center
    ]),
  };

  static List<Coordinate> _buildPath({
    required int startIndex,
    required List<Coordinate> homeColumn,
  }) {
    final List<Coordinate> path = [];
    // 51 steps on the common circuit track
    for (int i = 0; i < 51; i++) {
      path.add(mainCircuit[(startIndex + i) % mainCircuit.length]);
    }
    // 6 steps up the home column (5 entry tiles + 1 center home triangle)
    path.addAll(homeColumn);
    return path; // Length = 57 (indices 0..56)
  }

  static Coordinate getCoordinate(PlayerColor color, int stepIndex) {
    if (stepIndex < 0 || stepIndex >= 57) {
      throw ArgumentError('Step index $stepIndex out of range for $color');
    }
    return playerPaths[color]![stepIndex];
  }

  static bool isHomeColumn(PlayerColor color, int stepIndex) {
    return stepIndex >= 51;
  }
}
