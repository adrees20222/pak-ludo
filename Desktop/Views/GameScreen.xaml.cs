using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using PakLudo.Controls;
using PakLudo.Game;
using PakLudo.Models;

namespace PakLudo.Views
{
    public partial class GameScreen : UserControl
    {
        public event Action? HomeRequested;
        public event Action? RestartRequested;

        private GameEngine _engine = new();
        private readonly Dictionary<TokenModel, AnimatedTokenControl> _tokenControls = new();
        private List<PlayerModel> _initialPlayers = new();

        public GameScreen()
        {
            InitializeComponent();

            GameDice.DiceClicked += OnDiceClicked;
            VictoryOverlay.PlayAgainClicked += OnPlayAgain;
            VictoryOverlay.HomeClicked += OnHomeFromVictory;
        }

        public void StartNewMatch(List<PlayerModel> players)
        {
            _initialPlayers = players;
            VictoryOverlay.Visibility = Visibility.Collapsed;

            _engine = new GameEngine();
            _engine.OnTurnChanged += Engine_OnTurnChanged;
            _engine.OnDiceRolled += Engine_OnDiceRolled;
            _engine.OnTokenStepSequence += Engine_OnTokenStepSequence;
            _engine.OnGameFinished += Engine_OnGameFinished;
            _engine.OnStateUpdated += Engine_OnStateUpdated;

            _engine.StartGame(players);
            RebuildTokens();
            UpdateUI();
        }

        private void RebuildTokens()
        {
            TokenCanvas.Children.Clear();
            _tokenControls.Clear();

            double tokenSize = 26.0;

            foreach (var player in _engine.Players)
            {
                foreach (var token in player.Tokens)
                {
                    var tokenControl = new AnimatedTokenControl();
                    tokenControl.BindToken(token, tokenSize);
                    tokenControl.TokenClicked += OnTokenClicked;

                    _tokenControls[token] = tokenControl;
                    TokenCanvas.Children.Add(tokenControl);
                }
            }

            PositionAllTokens();
        }

        private void PositionAllTokens()
        {
            if (_engine == null || _engine.Players.Count == 0 || _tokenControls.Count == 0) return;

            // Group tokens by coordinate to offset overlapping tokens nicely
            var grouped = _engine.Players
                .SelectMany(p => p.Tokens)
                .GroupBy(t => t.Coordinate);

            double tokenSize = 26.0;

            foreach (var group in grouped)
            {
                var list = group.ToList();
                var center = BoardControl.GetCellCenter(group.Key);

                if (list.Count == 1)
                {
                    if (_tokenControls.TryGetValue(list[0], out var tc))
                    {
                        Canvas.SetLeft(tc, center.X - tokenSize / 2.0);
                        Canvas.SetTop(tc, center.Y - tokenSize / 2.0);
                    }
                }
                else
                {
                    // Mini offset arrangement for stacked tokens
                    for (int i = 0; i < list.Count; i++)
                    {
                        if (_tokenControls.TryGetValue(list[i], out var tc))
                        {
                            double angle = (2.0 * Math.PI / list.Count) * i;
                            double radius = 7.0;
                            double ox = Math.Cos(angle) * radius;
                            double oy = Math.Sin(angle) * radius;

                            Canvas.SetLeft(tc, center.X + ox - tokenSize / 2.0);
                            Canvas.SetTop(tc, center.Y + oy - tokenSize / 2.0);
                        }
                    }
                }
            }
        }

        private void UpdateUI()
        {
            if (_engine.Players.Count == 0) return;

            var curr = _engine.CurrentPlayer;
            TurnBanner.Background = PlayerColorHelper.GetBaseBrush(curr.Color);
            TurnBanner.BorderBrush = PlayerColorHelper.GetBrush(curr.Color);
            TurnColorBadge.Fill = PlayerColorHelper.GetBrush(curr.Color);
            TurnPlayerName.Text = curr.Name + (curr.IsBot ? " 🤖" : "");
            TurnPlayerName.Foreground = PlayerColorHelper.GetBrush(curr.Color);

            GameDice.SetPlayerColor(curr.Color);
            GameDice.SetValue(_engine.CurrentDiceNumber, _engine.IsRolling, _engine.HasPendingMove);

            if (_engine.IsRolling)
            {
                TurnStatusMessage.Text = "• Rolling...";
                DiceInstructionText.Text = "Rolling dice...";
            }
            else if (_engine.HasPendingMove)
            {
                TurnStatusMessage.Text = "• Select Token";
                DiceInstructionText.Text = curr.IsBot ? "Bot moving..." : "Tap glowing token to move";
            }
            else
            {
                TurnStatusMessage.Text = "• Roll Dice";
                DiceInstructionText.Text = curr.IsBot ? "Bot rolling..." : "Click dice to roll";
            }

            // Update token movable visuals
            foreach (var (token, control) in _tokenControls)
            {
                control.UpdateMovableState(token.IsMovable);
            }

            UpdatePlayersList();
        }

        private void UpdatePlayersList()
        {
            PlayersListContainer.Children.Clear();

            foreach (var p in _engine.Players)
            {
                bool isCurrent = (p == _engine.CurrentPlayer);
                var row = new Border
                {
                    Background = isCurrent ? PlayerColorHelper.GetBaseBrush(p.Color) : Brushes.Transparent,
                    BorderBrush = isCurrent ? PlayerColorHelper.GetBrush(p.Color) : Brushes.Transparent,
                    BorderThickness = new Thickness(1),
                    CornerRadius = new CornerRadius(8),
                    Padding = new Thickness(10, 6, 10, 6),
                    Margin = new Thickness(0, 0, 0, 6)
                };

                var grid = new Grid();
                grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(24) });
                grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
                grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

                var dot = new Ellipse
                {
                    Width = 12,
                    Height = 12,
                    Fill = PlayerColorHelper.GetBrush(p.Color),
                    VerticalAlignment = VerticalAlignment.Center
                };
                Grid.SetColumn(dot, 0);

                var nameBlock = new TextBlock
                {
                    Text = p.Name + (p.IsBot ? " 🤖" : ""),
                    FontWeight = isCurrent ? FontWeights.Bold : FontWeights.Normal,
                    FontSize = 13,
                    Foreground = isCurrent ? PlayerColorHelper.GetBrush(p.Color) : new SolidColorBrush(Color.FromRgb(51, 65, 85)),
                    VerticalAlignment = VerticalAlignment.Center
                };
                Grid.SetColumn(nameBlock, 1);

                string statusText = p.IsFinished ? $"🏆 Rank #{p.Rank}" : $"🏠 {p.FinishedTokensCount}/4";
                var scoreBlock = new TextBlock
                {
                    Text = statusText,
                    FontSize = 12,
                    FontWeight = FontWeights.SemiBold,
                    Foreground = new SolidColorBrush(Color.FromRgb(100, 116, 139)),
                    VerticalAlignment = VerticalAlignment.Center
                };
                Grid.SetColumn(scoreBlock, 2);

                grid.Children.Add(dot);
                grid.Children.Add(nameBlock);
                grid.Children.Add(scoreBlock);

                row.Child = grid;
                PlayersListContainer.Children.Add(row);
            }
        }

        private async void OnDiceClicked()
        {
            if (_engine.CurrentPlayer.IsBot || _engine.HasPendingMove || _engine.IsRolling || _engine.IsGameOver) return;
            await _engine.RollDiceAsync();
        }

        private async void OnTokenClicked(TokenModel token)
        {
            if (_engine.CurrentPlayer.IsBot || !_engine.HasPendingMove || !token.IsMovable) return;
            await _engine.ExecuteMoveAsync(token);
        }

        private void Engine_OnTurnChanged(PlayerModel player) => Dispatcher.Invoke(UpdateUI);
        private void Engine_OnDiceRolled(int roll) => Dispatcher.Invoke(UpdateUI);
        private void Engine_OnStateUpdated() => Dispatcher.Invoke(() => { PositionAllTokens(); UpdateUI(); });

        private void Engine_OnTokenStepSequence(TokenModel token, List<Coordinate> sequence)
        {
            Dispatcher.Invoke(() =>
            {
                PositionAllTokens();
                UpdateUI();
            });
        }

        private void Engine_OnGameFinished(List<PlayerModel> winners)
        {
            Dispatcher.Invoke(() =>
            {
                VictoryOverlay.SetWinners(winners);
                VictoryOverlay.Visibility = Visibility.Visible;
            });
        }

        private void OnBoardSizeChanged(object sender, SizeChangedEventArgs e)
        {
            PositionAllTokens();
        }

        private void OnSoundToggleClicked(object sender, RoutedEventArgs e)
        {
            SoundManager.IsMuted = !SoundManager.IsMuted;
            SoundToggleButton.Content = SoundManager.IsMuted ? "🔇 Sound: OFF" : "🔊 Sound: ON";
        }

        private void OnRestartClicked(object sender, RoutedEventArgs e)
        {
            if (MessageBox.Show("Are you sure you want to restart the current match?", "Restart Match",
                MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes)
            {
                StartNewMatch(_initialPlayers);
            }
        }

        private void OnHomeClicked(object sender, RoutedEventArgs e)
        {
            if (!_engine.IsGameOver)
            {
                if (MessageBox.Show("Quit match and return to Main Menu?", "Quit Match",
                    MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                {
                    return;
                }
            }
            HomeRequested?.Invoke();
        }

        private void OnPlayAgain() => StartNewMatch(_initialPlayers);
        private void OnHomeFromVictory() => HomeRequested?.Invoke();
    }
}
