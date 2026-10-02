namespace PakLudo.Models
{
    public class TokenModel
    {
        public int Id { get; set; }
        public PlayerColor Color { get; set; }
        public int PathIndex { get; set; } = -1; // -1 means in Base/Yard; 0..56 means on Path (56 is Home)
        public Coordinate Coordinate { get; set; }
        public bool IsLocked => PathIndex == -1;
        public bool IsHome => PathIndex >= 56;
        public bool IsActive { get; set; }
        public bool IsMovable { get; set; }

        public TokenModel(int id, PlayerColor color, Coordinate defaultCoord)
        {
            Id = id;
            Color = color;
            Coordinate = defaultCoord;
        }

        public void ResetToBase(Coordinate baseCoord)
        {
            PathIndex = -1;
            Coordinate = baseCoord;
            IsActive = false;
            IsMovable = false;
        }
    }
}
