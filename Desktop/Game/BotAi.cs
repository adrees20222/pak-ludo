using System.Collections.Generic;
using System.Linq;
using PakLudo.Models;

namespace PakLudo.Game
{
    public static class BotAi
    {
        public static TokenModel? SelectBestToken(PlayerModel botPlayer, List<PlayerModel> allPlayers, int diceNumber)
        {
            var movableTokens = new List<TokenModel>();

            foreach (var token in botPlayer.Tokens)
            {
                if (token.IsHome) continue;

                if (token.IsLocked)
                {
                    if (diceNumber == 6)
                    {
                        movableTokens.Add(token);
                    }
                }
                else
                {
                    int targetStep = token.PathIndex + diceNumber;
                    if (targetStep <= 56)
                    {
                        movableTokens.Add(token);
                    }
                }
            }

            if (movableTokens.Count == 0) return null;
            if (movableTokens.Count == 1) return movableTokens[0];

            TokenModel? bestToken = null;
            double bestScore = -999999;

            foreach (var token in movableTokens)
            {
                double score = 0;

                // 1. Unlocking from base on 6
                if (token.IsLocked)
                {
                    score += 600;
                    var startCoord = PathData.GetCoordinate(token.Color, 0);
                    bool hasOwnAtStart = botPlayer.Tokens.Any(t => !t.IsLocked && !t.IsHome && t.Coordinate == startCoord);
                    if (hasOwnAtStart)
                    {
                        score -= 100;
                    }
                }
                else
                {
                    int targetStep = token.PathIndex + diceNumber;
                    var targetCoord = PathData.GetCoordinate(token.Color, targetStep);

                    // 2. Reaching Home
                    if (targetStep == 56)
                    {
                        score += 1000;
                    }

                    // 3. Capturing opponent
                    if (!PathData.IsHomeColumn(targetStep) && !BoardConstants.IsSafeCoordinate(targetCoord))
                    {
                        bool canCapture = allPlayers
                            .Where(p => p.Color != token.Color)
                            .SelectMany(p => p.Tokens)
                            .Any(t => !t.IsLocked && !t.IsHome && t.Coordinate == targetCoord);

                        if (canCapture)
                        {
                            score += 1200; // Highest priority
                        }
                    }

                    // 4. Safe Star Spot
                    if (BoardConstants.IsSafeCoordinate(targetCoord))
                    {
                        score += 450;
                    }

                    // 5. Entering Home Run Safe Column
                    if (targetStep >= 51 && token.PathIndex < 51)
                    {
                        score += 500;
                    }

                    // 6. Escape from behind threat
                    if (!BoardConstants.IsSafeCoordinate(token.Coordinate) && token.PathIndex < 51)
                    {
                        bool isThreatened = false;
                        foreach (var opp in allPlayers.Where(p => p.Color != token.Color))
                        {
                            foreach (var oppToken in opp.Tokens.Where(t => !t.IsLocked && !t.IsHome && !PathData.IsHomeColumn(t.PathIndex)))
                            {
                                int dist = CalculateDistance(oppToken, token);
                                if (dist >= 1 && dist <= 6)
                                {
                                    isThreatened = true;
                                    break;
                                }
                            }
                            if (isThreatened) break;
                        }

                        if (isThreatened)
                        {
                            score += 350;
                        }
                    }

                    // 7. General progress bonus
                    score += token.PathIndex * 5.0;
                }

                if (score > bestScore)
                {
                    bestScore = score;
                    bestToken = token;
                }
            }

            return bestToken ?? movableTokens[0];
        }

        private static int CalculateDistance(TokenModel chaser, TokenModel target)
        {
            if (chaser.IsLocked || target.IsLocked) return -1;
            int chaserIdx = PathData.MainCircuit.IndexOf(chaser.Coordinate);
            int targetIdx = PathData.MainCircuit.IndexOf(target.Coordinate);
            if (chaserIdx == -1 || targetIdx == -1) return -1;
            return (targetIdx - chaserIdx + 52) % 52;
        }
    }
}
