using System.Windows.Media;

namespace PakLudo.Models
{
    public enum PlayerColor
    {
        Green,
        Yellow,
        Blue,
        Red
    }

    public static class PlayerColorHelper
    {
        public static string GetName(PlayerColor color) => color switch
        {
            PlayerColor.Green => "Green",
            PlayerColor.Yellow => "Yellow",
            PlayerColor.Blue => "Blue",
            PlayerColor.Red => "Red",
            _ => color.ToString()
        };

        public static Color GetColor(PlayerColor color) => color switch
        {
            PlayerColor.Green => Color.FromRgb(1, 65, 28),     // Pakistani Emerald #01411C
            PlayerColor.Yellow => Color.FromRgb(217, 119, 6),  // Amber/Gold #D97706
            PlayerColor.Blue => Color.FromRgb(37, 99, 235),    // Royal Blue #2563EB
            PlayerColor.Red => Color.FromRgb(220, 38, 38),     // Crimson Red #DC2626
            _ => Colors.Gray
        };

        public static Color GetLightColor(PlayerColor color) => color switch
        {
            PlayerColor.Green => Color.FromRgb(13, 110, 56),   // Emerald Light #0D6E38
            PlayerColor.Yellow => Color.FromRgb(245, 158, 11), // Gold Light #F59E0B
            PlayerColor.Blue => Color.FromRgb(59, 130, 246),   // Blue Light #3B82F6
            PlayerColor.Red => Color.FromRgb(239, 68, 68),     // Red Light #EF4444
            _ => Colors.LightGray
        };

        public static Color GetBaseBackgroundColor(PlayerColor color) => color switch
        {
            PlayerColor.Green => Color.FromRgb(236, 253, 245), // Emerald light tint
            PlayerColor.Yellow => Color.FromRgb(254, 243, 199),// Amber light tint
            PlayerColor.Blue => Color.FromRgb(239, 246, 255),  // Blue light tint
            PlayerColor.Red => Color.FromRgb(254, 242, 242),   // Red light tint
            _ => Colors.White
        };

        public static SolidColorBrush GetBrush(PlayerColor color) => new(GetColor(color));
        public static SolidColorBrush GetLightBrush(PlayerColor color) => new(GetLightColor(color));
        public static SolidColorBrush GetBaseBrush(PlayerColor color) => new(GetBaseBackgroundColor(color));
    }
}
