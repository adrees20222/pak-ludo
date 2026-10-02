using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using PakLudo.Models;

namespace PakLudo.Game
{
    public class GameEngine
    {
        public List<PlayerModel> Players { get; private set; } = new();
        public int CurrentPlayerIndex { get; private set; } = 0;
        public PlayerModel CurrentPlayer => Players[CurrentPlayerIndex];
        public int? CurrentDiceNumber { get; private set; }
        public bool IsRolling { get; set; }
        public bool HasPendingMove { get; private set; }
        public int ConsecutiveSixes { get; private set; } = 0;
        public List<PlayerModel> Winners { get; private set; } = new();
        public bool IsGameOver { get; private set; } = false;

        public event Action<int>? OnDiceRolled;
        public event Action<PlayerModel>? OnTurnChanged;
        public event Action<TokenModel, List<Coordinate>>? OnTokenStepSequence;
        public event Action<TokenModel>? OnTokenCaptured;
        public event Action<TokenModel>? OnTokenReachedHome;
        public event Action<List<PlayerModel>>? OnGameFinished;
        public event Action? OnStateUpdated;

        private readonly Random _rand = new();

        public void StartGame(List<PlayerModel> players)
        {
            Players = players;
            CurrentPlayerIndex = 0;
            CurrentDiceNumber = null;
            IsRolling = false;
            HasPendingMove = false;
            ConsecutiveSixes = 0;
            Winners.Clear();
            IsGameOver = false;

            // Initialize tokens in their respective base yards
            foreach (var player in Players)
            {
                player.Tokens.Clear();
                player.Rank = 0;
                var baseCoords = BoardConstants.BaseYardCoords[player.Color];
                for (int i = 0; i < 4; i++)
                {
                    player.Tokens.Add(new TokenModel(i, player.Color, baseCoords[i]));
                }
            }

            OnStateUpdated?.Invoke();
            OnTurnChanged?.Invoke(CurrentPlayer);

            if (CurrentPlayer.IsBot && !IsGameOver)
            {
                Task.Run(async () =>
                {
                    await Task.Delay(600);
                    await RollDiceAsync();
                });
            }
        }

        public async Task RollDiceAsync()
        {
            if (IsRolling || HasPendingMove || IsGameOver) return;

            IsRolling = true;
            SoundManager.PlayDiceRoll();

            // Quick dice rolling animation cycles
            for (int i = 0; i < 8; i++)
            {
                CurrentDiceNumber = _rand.Next(1, 7);
                OnStateUpdated?.Invoke();
                await Task.Delay(40);
            }

            int finalRoll = _rand.Next(1, 7);
            CurrentDiceNumber = finalRoll;
            IsRolling = false;
            OnDiceRolled?.Invoke(finalRoll);

            if (finalRoll == 6)
            {
                ConsecutiveSixes++;
                if (ConsecutiveSixes >= 3)
                {
                    // Penalty for 3 consecutive sixes: lose turn
                    ConsecutiveSixes = 0;
                    CurrentDiceNumber = null;
                    HasPendingMove = false;
                    NextTurn(false);
                    return;
                }
            }
            else
            {
                ConsecutiveSixes = 0;
            }

            var movableTokens = GetMovableTokens(CurrentPlayer, finalRoll);

            if (movableTokens.Count == 0)
            {
                // No valid moves, advance to next player after brief delay
                HasPendingMove = false;
                await Task.Delay(700);
                CurrentDiceNumber = null;
                NextTurn(false);
            }
            else
            {
                HasPendingMove = true;
                foreach (var t in CurrentPlayer.Tokens)
                {
                    t.IsMovable = movableTokens.Contains(t);
                    t.IsActive = t.IsMovable;
                }
                OnStateUpdated?.Invoke();

                // If single move or Bot player, execute automatically
                if (CurrentPlayer.IsBot)
                {
                    await Task.Delay(500);
                    var chosen = BotAi.SelectBestToken(CurrentPlayer, Players, finalRoll);
                    if (chosen != null)
                    {
                        await ExecuteMoveAsync(chosen);
                    }
                }
                else if (movableTokens.Count == 1)
                {
                    // Automatically move single valid token for human convenience
                    await Task.Delay(300);
                    await ExecuteMoveAsync(movableTokens[0]);
                }
            }
        }

        public async Task ExecuteMoveAsync(TokenModel token)
        {
            if (!HasPendingMove || CurrentDiceNumber == null) return;
            if (token.Color != CurrentPlayer.Color || !token.IsMovable) return;

            HasPendingMove = false;
            int dice = CurrentDiceNumber.Value;
            CurrentDiceNumber = null;

            // Clear active flags
            foreach (var t in CurrentPlayer.Tokens)
            {
                t.IsActive = false;
                t.IsMovable = false;
            }
            OnStateUpdated?.Invoke();

            bool grantBonusTurn = (dice == 6);
            var stepSequence = new List<Coordinate>();

            if (token.IsLocked)
            {
                // Unlocking token onto starting tile (index 0)
                token.PathIndex = 0;
                token.Coordinate = PathData.GetCoordinate(token.Color, 0);
                stepSequence.Add(token.Coordinate);
                SoundManager.PlayTokenStep();
            }
            else
            {
                // Step forward tile-by-tile
                int start = token.PathIndex;
                int target = start + dice;

                for (int s = start + 1; s <= target; s++)
                {
                    stepSequence.Add(PathData.GetCoordinate(token.Color, s));
                }

                token.PathIndex = target;
                token.Coordinate = PathData.GetCoordinate(token.Color, target);

                // Play step sequence sound
                SoundManager.PlayTokenStep();

                // Check if reached home
                if (token.IsHome)
                {
                    grantBonusTurn = true;
                    SoundManager.PlayVictory();
                    OnTokenReachedHome?.Invoke(token);
                }
                else if (BoardConstants.IsSafeCoordinate(token.Coordinate))
                {
                    SoundManager.PlaySafeStar();
                }
                else
                {
                    // Check for capture on non-safe tiles
                    var capturedTokens = new List<TokenModel>();
                    foreach (var opponent in Players.Where(p => p.Color != token.Color))
                    {
                        foreach (var oppToken in opponent.Tokens.Where(t => !t.IsLocked && !t.IsHome && t.Coordinate == token.Coordinate))
                        {
                            capturedTokens.Add(oppToken);
                        }
                    }

                    if (capturedTokens.Count > 0)
                    {
                        grantBonusTurn = true;
                        SoundManager.PlayCapture();
                        foreach (var captured in capturedTokens)
                        {
                            var baseCoords = BoardConstants.BaseYardCoords[captured.Color];
                            captured.ResetToBase(baseCoords[captured.Id]);
                            OnTokenCaptured?.Invoke(captured);
                        }
                    }
                }
            }

            OnTokenStepSequence?.Invoke(token, stepSequence);
            OnStateUpdated?.Invoke();

            // Check if current player just finished
            if (CurrentPlayer.Tokens.All(t => t.IsHome) && !CurrentPlayer.IsFinished)
            {
                CurrentPlayer.Rank = Winners.Count + 1;
                Winners.Add(CurrentPlayer);
            }

            // Check if game is over (all or all-but-one finished)
            int unfinishedCount = Players.Count(p => !p.IsFinished);
            if (unfinishedCount <= 1)
            {
                // Add last remaining player
                var last = Players.FirstOrDefault(p => !p.IsFinished);
                if (last != null)
                {
                    last.Rank = Winners.Count + 1;
                    Winners.Add(last);
                }

                IsGameOver = true;
                SoundManager.PlayVictory();
                OnGameFinished?.Invoke(Winners);
                OnStateUpdated?.Invoke();
                return;
            }

            // Advance turn or grant bonus turn
            await Task.Delay(400);
            NextTurn(grantBonusTurn);
        }

        private void NextTurn(bool grantBonusTurn)
        {
            if (IsGameOver) return;

            if (!grantBonusTurn || CurrentPlayer.IsFinished)
            {
                // Pass turn to next active unfinished player
                do
                {
                    CurrentPlayerIndex = (CurrentPlayerIndex + 1) % Players.Count;
                } while (CurrentPlayer.IsFinished);
            }

            OnTurnChanged?.Invoke(CurrentPlayer);
            OnStateUpdated?.Invoke();

            // If new player is bot, trigger automatic roll
            if (CurrentPlayer.IsBot && !IsGameOver)
            {
                Task.Run(async () =>
                {
                    await Task.Delay(600);
                    await RollDiceAsync();
                });
            }
        }

        public List<TokenModel> GetMovableTokens(PlayerModel player, int diceNumber)
        {
            var list = new List<TokenModel>();
            foreach (var token in player.Tokens)
            {
                if (token.IsHome) continue;

                if (token.IsLocked)
                {
                    if (diceNumber == 6) list.Add(token);
                }
                else
                {
                    if (token.PathIndex + diceNumber <= 56) list.Add(token);
                }
            }
            return list;
        }
    }
}
