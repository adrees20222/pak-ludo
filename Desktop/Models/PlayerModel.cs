using System.Collections.Generic;

namespace PakLudo.Models
{
    public class PlayerModel
    {
        public PlayerColor Color { get; set; }
        public string Name { get; set; }
        public bool IsBot { get; set; }
        public List<TokenModel> Tokens { get; set; } = new();
        public int Rank { get; set; } = 0; // 0 = not finished; 1, 2, 3, 4 = finished position
        public bool IsFinished => Rank > 0;
        public int FinishedTokensCount => Tokens.FindAll(t => t.IsHome).Count;

        public PlayerModel(PlayerColor color, string name, bool isBot)
        {
            Color = color;
            Name = name;
            IsBot = isBot;
        }
    }
}
