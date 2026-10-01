import 'dart:math';
import 'package:flutter/material.dart';
import '../../game/board_constants.dart';
import '../../models/coordinate.dart';
import '../../models/player_color.dart';

class LudoBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tileSize = size.width / 15.0;

    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final borderPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 1. Draw 4 Corner Yards (6x6 tiles each)
    _drawYard(canvas, 0, 0, 6 * tileSize, PlayerColor.red);
    _drawYard(canvas, 9 * tileSize, 0, 6 * tileSize, PlayerColor.green);
    _drawYard(canvas, 9 * tileSize, 9 * tileSize, 6 * tileSize, PlayerColor.yellow);
    _drawYard(canvas, 0, 9 * tileSize, 6 * tileSize, PlayerColor.blue);

    // 2. Draw 15x15 grid lines and track tiles
    for (int x = 0; x < 15; x++) {
      for (int y = 0; y < 15; y++) {
        // Skip yard interiors and center triangle
        final inRedYard = x < 6 && y < 6;
        final inGreenYard = x >= 9 && y < 6;
        final inYellowYard = x >= 9 && y >= 9;
        final inBlueYard = x < 6 && y >= 9;
        final inCenter = x >= 6 && x <= 8 && y >= 6 && y <= 8;

        if (inRedYard || inGreenYard || inYellowYard || inBlueYard || inCenter) {
          continue;
        }

        final rect = Rect.fromLTWH(x * tileSize, y * tileSize, tileSize, tileSize);

        // Highlight Home Columns & Start Tiles
        Color tileColor = Colors.white;

        // Red track & entry
        if (x == 1 && y == 6) tileColor = PlayerColor.red.color;
        if (y == 7 && x >= 1 && x <= 5) tileColor = PlayerColor.red.color;

        // Green track & entry
        if (x == 8 && y == 1) tileColor = PlayerColor.green.color;
        if (x == 7 && y >= 1 && y <= 5) tileColor = PlayerColor.green.color;

        // Yellow track & entry
        if (x == 13 && y == 8) tileColor = PlayerColor.yellow.color;
        if (y == 7 && x >= 9 && x <= 13) tileColor = PlayerColor.yellow.color;

        // Blue track & entry
        if (x == 6 && y == 13) tileColor = PlayerColor.blue.color;
        if (x == 7 && y >= 9 && y <= 13) tileColor = PlayerColor.blue.color;

        final fillPaint = Paint()..color = tileColor;
        canvas.drawRect(rect, fillPaint);
        canvas.drawRect(rect, borderPaint);

        // Draw Star on Safe Coordinates
        final coord = Coordinate(x, y);
        if (BoardConstants.isSafeCoordinate(coord)) {
          _drawStar(
            canvas,
            rect.center,
            tileSize * 0.35,
            tileColor == Colors.white ? const Color(0xFF64748B) : Colors.white,
          );
        }
      }
    }

    // 3. Draw Center Home Triangles (6..8, 6..8)
    _drawCenterHome(canvas, 6 * tileSize, 6 * tileSize, 3 * tileSize);

    // 4. Outer Board Border
    final outerBorder = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), outerBorder);
  }

  void _drawYard(Canvas canvas, double x, double y, double size, PlayerColor color) {
    final yardRect = Rect.fromLTWH(x, y, size, size);
    final fillPaint = Paint()..color = color.color;
    canvas.drawRect(yardRect, fillPaint);

    final borderPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(yardRect, borderPaint);

    // Inner White Box (4x4 tiles equivalent)
    final padding = size * 0.16;
    final innerRect = Rect.fromLTWH(
      x + padding,
      y + padding,
      size - (2 * padding),
      size - (2 * padding),
    );
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(innerRect, Radius.circular(size * 0.08)),
      innerPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(innerRect, Radius.circular(size * 0.08)),
      borderPaint,
    );

    // 4 Token Seat Circles
    final seatRadius = size * 0.12;
    final coords = BoardConstants.baseYardCoords[color]!;
    final tileSize = size / 6.0;

    for (final c in coords) {
      final cx = (c.x + 0.5) * tileSize;
      final cy = (c.y + 0.5) * tileSize;
      final seatPaint = Paint()..color = color.color;
      canvas.drawCircle(Offset(cx, cy), seatRadius, seatPaint);
      canvas.drawCircle(Offset(cx, cy), seatRadius, borderPaint);
    }
  }

  void _drawCenterHome(Canvas canvas, double x, double y, double size) {
    final center = Offset(x + size / 2, y + size / 2);
    final topLeft = Offset(x, y);
    final topRight = Offset(x + size, y);
    final bottomRight = Offset(x + size, y + size);
    final bottomLeft = Offset(x, y + size);

    // Red (Left)
    _drawTriangle(canvas, topLeft, bottomLeft, center, PlayerColor.red.color);
    // Green (Top)
    _drawTriangle(canvas, topLeft, topRight, center, PlayerColor.green.color);
    // Yellow (Right)
    _drawTriangle(canvas, topRight, bottomRight, center, PlayerColor.yellow.color);
    // Blue (Bottom)
    _drawTriangle(canvas, bottomLeft, bottomRight, center, PlayerColor.blue.color);

    final border = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRect(Rect.fromLTWH(x, y, size, size), border);
  }

  void _drawTriangle(Canvas canvas, Offset p1, Offset p2, Offset p3, Color color) {
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    const numPoints = 5;
    final halfRadius = radius / 2;

    for (int i = 0; i < numPoints * 2; i++) {
      final r = i.isEven ? radius : halfRadius;
      final angle = i * pi / numPoints - pi / 2;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
