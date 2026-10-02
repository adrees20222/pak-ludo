using System;
using System.Globalization;
using System.Windows;
using System.Windows.Media;
using PakLudo.Game;
using PakLudo.Models;

namespace PakLudo.Controls
{
    public class LudoBoardControl : FrameworkElement
    {
        private static readonly Pen GridPen = new(new SolidColorBrush(Color.FromArgb(50, 15, 23, 42)), 1.0);
        private static readonly Pen BorderPen = new(new SolidColorBrush(Color.FromRgb(15, 23, 42)), 2.5);
        private static readonly SolidColorBrush NeutralTileBrush = new(Color.FromRgb(255, 255, 255));
        private static readonly SolidColorBrush SafeStarBrush = new(Color.FromRgb(245, 158, 11)); // Gold star

        static LudoBoardControl()
        {
            GridPen.Freeze();
            BorderPen.Freeze();
            NeutralTileBrush.Freeze();
            SafeStarBrush.Freeze();
        }

        protected override void OnRender(DrawingContext dc)
        {
            base.OnRender(dc);

            double size = Math.Min(ActualWidth, ActualHeight);
            if (size <= 0) return;

            double cellSize = size / 15.0;
            double offsetX = (ActualWidth - size) / 2.0;
            double offsetY = (ActualHeight - size) / 2.0;

            // 1. Draw Board Background Container
            var boardRect = new Rect(offsetX, offsetY, size, size);
            dc.DrawRectangle(Brushes.White, BorderPen, boardRect);

            // 2. Draw 4 Corner Yards (6x6 cells each)
            // Top-Left: Red
            DrawYard(dc, offsetX, offsetY, cellSize, 0, 0, PlayerColor.Red);
            // Top-Right: Green
            DrawYard(dc, offsetX, offsetY, cellSize, 0, 9, PlayerColor.Green);
            // Bottom-Right: Yellow
            DrawYard(dc, offsetX, offsetY, cellSize, 9, 9, PlayerColor.Yellow);
            // Bottom-Left: Blue
            DrawYard(dc, offsetX, offsetY, cellSize, 9, 0, PlayerColor.Blue);

            // 3. Draw Track Grid (Center tracks & columns)
            DrawTracks(dc, offsetX, offsetY, cellSize);

            // 4. Draw Center Home Triangles (3x3 area: rows 6..8, cols 6..8)
            DrawCenterHome(dc, offsetX, offsetY, cellSize);

            // 5. Draw 8 Safe Stars
            DrawSafeStars(dc, offsetX, offsetY, cellSize);
        }

        private void DrawYard(DrawingContext dc, double ox, double oy, double cs, int r, int c, PlayerColor color)
        {
            var rect = new Rect(ox + c * cs, oy + r * cs, 6 * cs, 6 * cs);
            dc.DrawRectangle(PlayerColorHelper.GetBaseBrush(color), BorderPen, rect);

            // Inner white box
            var innerRect = new Rect(ox + (c + 1) * cs, oy + (r + 1) * cs, 4 * cs, 4 * cs);
            dc.DrawRoundedRectangle(Brushes.White, new Pen(PlayerColorHelper.GetBrush(color), 2), innerRect, cs * 0.4, cs * 0.4);

            // 4 Base Token Circles
            var baseCoords = BoardConstants.BaseYardCoords[color];
            foreach (var coord in baseCoords)
            {
                var pt = new Point(ox + (coord.Col + 0.5) * cs, oy + (coord.Row + 0.5) * cs);
                dc.DrawEllipse(PlayerColorHelper.GetBrush(color), null, pt, cs * 0.4, cs * 0.4);
                dc.DrawEllipse(Brushes.White, null, pt, cs * 0.22, cs * 0.22);
            }
        }

        private void DrawTracks(DrawingContext dc, double ox, double oy, double cs)
        {
            for (int r = 0; r < 15; r++)
            {
                for (int c = 0; c < 15; c++)
                {
                    // Skip 4 corner yards and center 3x3
                    if ((r < 6 && c < 6) || (r < 6 && c > 8) || (r > 8 && c < 6) || (r > 8 && c > 8) || (r >= 6 && r <= 8 && c >= 6 && c <= 8))
                    {
                        continue;
                    }

                    var cellRect = new Rect(ox + c * cs, oy + r * cs, cs, cs);
                    var brush = NeutralTileBrush;

                    // Home Columns
                    if (r == 7 && c >= 1 && c <= 5) brush = PlayerColorHelper.GetBrush(PlayerColor.Red);         // Red Home Column (Left)
                    else if (c == 7 && r >= 1 && r <= 5) brush = PlayerColorHelper.GetBrush(PlayerColor.Green);   // Green Home Column (Top)
                    else if (r == 7 && c >= 9 && c <= 13) brush = PlayerColorHelper.GetBrush(PlayerColor.Yellow);// Yellow Home Column (Right)
                    else if (c == 7 && r >= 9 && r <= 13) brush = PlayerColorHelper.GetBrush(PlayerColor.Blue);  // Blue Home Column (Bottom)
                    
                    // Starting Squares
                    else if (r == 6 && c == 1) brush = PlayerColorHelper.GetLightBrush(PlayerColor.Red);         // Red Start
                    else if (r == 1 && c == 8) brush = PlayerColorHelper.GetLightBrush(PlayerColor.Green);       // Green Start
                    else if (r == 8 && c == 13) brush = PlayerColorHelper.GetLightBrush(PlayerColor.Yellow);     // Yellow Start
                    else if (r == 13 && c == 6) brush = PlayerColorHelper.GetLightBrush(PlayerColor.Blue);       // Blue Start

                    dc.DrawRectangle(brush, GridPen, cellRect);
                }
            }
        }

        private void DrawCenterHome(DrawingContext dc, double ox, double oy, double cs)
        {
            var center = new Point(ox + 7.5 * cs, oy + 7.5 * cs);

            // Left Triangle: RED (connected to Red Home Column)
            var redGeom = new StreamGeometry();
            using (var ctx = redGeom.Open())
            {
                ctx.BeginFigure(new Point(ox + 6 * cs, oy + 6 * cs), true, true);
                ctx.LineTo(new Point(ox + 6 * cs, oy + 9 * cs), true, false);
                ctx.LineTo(center, true, false);
            }
            dc.DrawGeometry(PlayerColorHelper.GetBrush(PlayerColor.Red), BorderPen, redGeom);

            // Top Triangle: GREEN (connected to Green Home Column)
            var greenGeom = new StreamGeometry();
            using (var ctx = greenGeom.Open())
            {
                ctx.BeginFigure(new Point(ox + 6 * cs, oy + 6 * cs), true, true);
                ctx.LineTo(new Point(ox + 9 * cs, oy + 6 * cs), true, false);
                ctx.LineTo(center, true, false);
            }
            dc.DrawGeometry(PlayerColorHelper.GetBrush(PlayerColor.Green), BorderPen, greenGeom);

            // Right Triangle: YELLOW (connected to Yellow Home Column)
            var yellowGeom = new StreamGeometry();
            using (var ctx = yellowGeom.Open())
            {
                ctx.BeginFigure(new Point(ox + 9 * cs, oy + 6 * cs), true, true);
                ctx.LineTo(new Point(ox + 9 * cs, oy + 9 * cs), true, false);
                ctx.LineTo(center, true, false);
            }
            dc.DrawGeometry(PlayerColorHelper.GetBrush(PlayerColor.Yellow), BorderPen, yellowGeom);

            // Bottom Triangle: BLUE (connected to Blue Home Column)
            var blueGeom = new StreamGeometry();
            using (var ctx = blueGeom.Open())
            {
                ctx.BeginFigure(new Point(ox + 6 * cs, oy + 9 * cs), true, true);
                ctx.LineTo(new Point(ox + 9 * cs, oy + 9 * cs), true, false);
                ctx.LineTo(center, true, false);
            }
            dc.DrawGeometry(PlayerColorHelper.GetBrush(PlayerColor.Blue), BorderPen, blueGeom);
        }

        private void DrawSafeStars(DrawingContext dc, double ox, double oy, double cs)
        {
            var typeface = new Typeface(new FontFamily("Segoe UI Symbol, Segoe UI"), FontStyles.Normal, FontWeights.Bold, FontStretches.Normal);

            foreach (var starCoord in BoardConstants.SafeStarCoordinates)
            {
                var ft = new FormattedText(
                    "★",
                    CultureInfo.InvariantCulture,
                    FlowDirection.LeftToRight,
                    typeface,
                    cs * 0.7,
                    SafeStarBrush,
                    VisualTreeHelper.GetDpi(this).PixelsPerDip
                );

                double px = ox + starCoord.Col * cs + (cs - ft.Width) / 2.0;
                double py = oy + starCoord.Row * cs + (cs - ft.Height) / 2.0;
                dc.DrawText(ft, new Point(px, py));
            }
        }

        public Point GetCellCenter(Coordinate coord)
        {
            double size = Math.Min(ActualWidth, ActualHeight);
            double cellSize = size / 15.0;
            double offsetX = (ActualWidth - size) / 2.0;
            double offsetY = (ActualHeight - size) / 2.0;

            return new Point(
                offsetX + (coord.Col + 0.5) * cellSize,
                offsetY + (coord.Row + 0.5) * cellSize
            );
        }
    }
}
