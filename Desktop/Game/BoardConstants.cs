using System.Collections.Generic;
using PakLudo.Models;

namespace PakLudo.Game
{
    public static class BoardConstants
    {
        public const int GridSize = 15;

        // Base Yard coordinates for each player's 4 tokens:
        // Top-Left: Red (Rows 0..5, Cols 0..5)
        // Top-Right: Green (Rows 0..5, Cols 9..14)
        // Bottom-Right: Yellow (Rows 9..14, Cols 9..14)
        // Bottom-Left: Blue (Rows 9..14, Cols 0..5)
        public static readonly Dictionary<PlayerColor, List<Coordinate>> BaseYardCoords = new()
        {
            [PlayerColor.Red] = new List<Coordinate>
            {
                new(1, 1), new(4, 1), new(1, 4), new(4, 4)
            },
            [PlayerColor.Green] = new List<Coordinate>
            {
                new(1, 10), new(4, 10), new(1, 13), new(4, 13)
            },
            [PlayerColor.Yellow] = new List<Coordinate>
            {
                new(10, 10), new(13, 10), new(10, 13), new(13, 13)
            },
            [PlayerColor.Blue] = new List<Coordinate>
            {
                new(10, 1), new(13, 1), new(10, 4), new(13, 4)
            },
        };

        // 8 Safe Star Spots (4 Starting Squares + 4 Track Stars)
        public static readonly HashSet<Coordinate> SafeStarCoordinates = new()
        {
            // 4 Starting squares
            new(6, 1),   // Red start
            new(1, 8),   // Green start
            new(8, 13),  // Yellow start
            new(13, 6),  // Blue start
            // 4 Track star squares
            new(2, 6),   // Top-Left star
            new(6, 12),  // Top-Right star
            new(12, 8),  // Bottom-Right star
            new(8, 2),   // Bottom-Left star
        };

        public static bool IsSafeCoordinate(Coordinate coord) => SafeStarCoordinates.Contains(coord);
    }
}
