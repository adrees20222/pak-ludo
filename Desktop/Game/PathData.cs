using System;
using System.Collections.Generic;
using PakLudo.Models;

namespace PakLudo.Game
{
    public static class PathData
    {
        // 52-tile shared outer circuit track (Clockwise, starting from Red Start at Row 6, Col 1)
        public static readonly List<Coordinate> MainCircuit = new()
        {
            new(6, 1),   // 0: Red Start
            new(6, 2),   // 1
            new(6, 3),   // 2
            new(6, 4),   // 3
            new(6, 5),   // 4
            new(5, 6),   // 5
            new(4, 6),   // 6
            new(3, 6),   // 7
            new(2, 6),   // 8: Top-Left Star
            new(1, 6),   // 9
            new(0, 6),   // 10
            new(0, 7),   // 11
            new(0, 8),   // 12
            new(1, 8),   // 13: Green Start
            new(2, 8),   // 14
            new(3, 8),   // 15
            new(4, 8),   // 16
            new(5, 8),   // 17
            new(6, 9),   // 18
            new(6, 10),  // 19
            new(6, 11),  // 20
            new(6, 12),  // 21: Top-Right Star
            new(6, 13),  // 22
            new(6, 14),  // 23
            new(7, 14),  // 24
            new(8, 14),  // 25
            new(8, 13),  // 26: Yellow Start
            new(8, 12),  // 27
            new(8, 11),  // 28
            new(8, 10),  // 29
            new(8, 9),   // 30
            new(9, 8),   // 31
            new(10, 8),  // 32
            new(11, 8),  // 33
            new(12, 8),  // 34: Bottom-Right Star
            new(13, 8),  // 35
            new(14, 8),  // 36
            new(14, 7),  // 37
            new(14, 6),  // 38
            new(13, 6),  // 39: Blue Start
            new(12, 6),  // 40
            new(11, 6),  // 41
            new(10, 6),  // 42
            new(9, 6),   // 43
            new(8, 5),   // 44
            new(8, 4),   // 45
            new(8, 3),   // 46
            new(8, 2),   // 47: Bottom-Left Star
            new(8, 1),   // 48
            new(8, 0),   // 49
            new(7, 0),   // 50
            new(6, 0),   // 51
        };

        public static readonly Dictionary<PlayerColor, List<Coordinate>> PlayerPaths = new()
        {
            [PlayerColor.Red] = BuildPath(0, new()
            {
                new(7, 1), new(7, 2), new(7, 3), new(7, 4), new(7, 5), new(7, 6)
            }),
            [PlayerColor.Green] = BuildPath(13, new()
            {
                new(1, 7), new(2, 7), new(3, 7), new(4, 7), new(5, 7), new(6, 7)
            }),
            [PlayerColor.Yellow] = BuildPath(26, new()
            {
                new(7, 13), new(7, 12), new(7, 11), new(7, 10), new(7, 9), new(7, 8)
            }),
            [PlayerColor.Blue] = BuildPath(39, new()
            {
                new(13, 7), new(12, 7), new(11, 7), new(10, 7), new(9, 7), new(8, 7)
            }),
        };

        private static List<Coordinate> BuildPath(int startIndex, List<Coordinate> homeColumn)
        {
            var path = new List<Coordinate>(57);
            for (int i = 0; i < 51; i++)
            {
                path.Add(MainCircuit[(startIndex + i) % MainCircuit.Count]);
            }
            path.AddRange(homeColumn);
            return path;
        }

        public static Coordinate GetCoordinate(PlayerColor color, int stepIndex)
        {
            if (stepIndex < 0 || stepIndex >= 57)
                throw new ArgumentOutOfRangeException(nameof(stepIndex), $"Step index {stepIndex} out of range (0..56).");
            return PlayerPaths[color][stepIndex];
        }

        public static bool IsHomeColumn(int stepIndex) => stepIndex >= 51;
    }
}
