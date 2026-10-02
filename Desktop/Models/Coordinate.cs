namespace PakLudo.Models
{
    public readonly record struct Coordinate(int Row, int Col)
    {
        public override string ToString() => $"({Row},{Col})";
    }
}
