import '../models/coordinate.dart';
import '../models/player_color.dart';

class BoardConstants {
  static const int gridSize = 15;

  // Base Yard coordinates for each token ID (0..3)
  static const Map<PlayerColor, List<Coordinate>> baseYardCoords = {
    PlayerColor.red: [
      Coordinate(1, 1),
      Coordinate(4, 1),
      Coordinate(1, 4),
      Coordinate(4, 4),
    ],
    PlayerColor.green: [
      Coordinate(10, 1),
      Coordinate(13, 1),
      Coordinate(10, 4),
      Coordinate(13, 4),
    ],
    PlayerColor.yellow: [
      Coordinate(10, 10),
      Coordinate(13, 10),
      Coordinate(10, 13),
      Coordinate(13, 13),
    ],
    PlayerColor.blue: [
      Coordinate(1, 10),
      Coordinate(4, 10),
      Coordinate(1, 13),
      Coordinate(4, 13),
    ],
  };

  // 8 Safe Star Spots
  static const List<Coordinate> safeStarCoordinates = [
    // 4 Start squares
    Coordinate(1, 6),   // Red start
    Coordinate(8, 1),   // Green start
    Coordinate(13, 8),  // Yellow start
    Coordinate(6, 13),  // Blue start
    // 4 Star squares
    Coordinate(2, 8),   // Bottom left star
    Coordinate(6, 2),   // Top left star
    Coordinate(12, 6),  // Top right star
    Coordinate(8, 12),  // Bottom right star
  ];

  static bool isSafeCoordinate(Coordinate coord) {
    return safeStarCoordinates.contains(coord);
  }
}
