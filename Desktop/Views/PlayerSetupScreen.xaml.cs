using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;
using PakLudo.Models;

namespace PakLudo.Views
{
    public partial class PlayerSetupScreen : UserControl
    {
        public event Action<List<PlayerModel>>? StartMatchRequested;
        public event Action? BackRequested;

        private class PlayerInputControl
        {
            public PlayerColor Color { get; set; }
            public TextBox NameBox { get; set; } = null!;
            public CheckBox BotCheckBox { get; set; } = null!;
        }

        private readonly List<PlayerInputControl> _inputControls = new();

        public PlayerSetupScreen()
        {
            InitializeComponent();
            BuildPlayerInputs(2);
        }

        private void OnPlayerCountChanged(object sender, RoutedEventArgs e)
        {
            if (Radio2Players == null || Radio3Players == null || Radio4Players == null) return;

            int count = 2;
            if (Radio3Players.IsChecked == true) count = 3;
            else if (Radio4Players.IsChecked == true) count = 4;

            BuildPlayerInputs(count);
        }

        private void BuildPlayerInputs(int count)
        {
            PlayerInputsContainer.Children.Clear();
            _inputControls.Clear();

            // Order: 2p: Red, Yellow; 3p: Red, Green, Yellow; 4p: Red, Green, Yellow, Blue
            PlayerColor[] colors = count switch
            {
                2 => new[] { PlayerColor.Red, PlayerColor.Yellow },
                3 => new[] { PlayerColor.Red, PlayerColor.Green, PlayerColor.Yellow },
                _ => new[] { PlayerColor.Red, PlayerColor.Green, PlayerColor.Yellow, PlayerColor.Blue }
            };

            for (int i = 0; i < colors.Length; i++)
            {
                var color = colors[i];
                var card = new Border
                {
                    Background = PlayerColorHelper.GetBaseBrush(color),
                    BorderBrush = PlayerColorHelper.GetBrush(color),
                    BorderThickness = new Thickness(1.5),
                    CornerRadius = new CornerRadius(12),
                    Padding = new Thickness(16, 12, 16, 12),
                    Margin = new Thickness(0, 0, 0, 10)
                };

                var grid = new Grid();
                grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(40) });
                grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
                grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

                var badge = new Ellipse
                {
                    Width = 24,
                    Height = 24,
                    Fill = PlayerColorHelper.GetBrush(color),
                    Stroke = Brushes.White,
                    StrokeThickness = 2,
                    HorizontalAlignment = HorizontalAlignment.Left
                };
                Grid.SetColumn(badge, 0);

                var nameBox = new TextBox
                {
                    Text = $"Player {i + 1} ({PlayerColorHelper.GetName(color)})",
                    FontSize = 15,
                    FontWeight = FontWeights.SemiBold,
                    Padding = new Thickness(8, 6, 8, 6),
                    Margin = new Thickness(0, 0, 12, 0),
                    VerticalAlignment = VerticalAlignment.Center,
                    BorderBrush = new SolidColorBrush(Color.FromRgb(203, 213, 225)),
                    Background = Brushes.White
                };
                Grid.SetColumn(nameBox, 1);

                var botCheck = new CheckBox
                {
                    Content = "🤖 AI Bot",
                    IsChecked = (i > 0), // Default player 1 is Human, others are Bot
                    FontSize = 14,
                    FontWeight = FontWeights.SemiBold,
                    VerticalAlignment = VerticalAlignment.Center
                };
                Grid.SetColumn(botCheck, 2);

                grid.Children.Add(badge);
                grid.Children.Add(nameBox);
                grid.Children.Add(botCheck);

                card.Child = grid;
                PlayerInputsContainer.Children.Add(card);

                _inputControls.Add(new PlayerInputControl
                {
                    Color = color,
                    NameBox = nameBox,
                    BotCheckBox = botCheck
                });
            }
        }

        private void OnStartMatchClicked(object sender, RoutedEventArgs e)
        {
            var players = new List<PlayerModel>();

            foreach (var input in _inputControls)
            {
                string name = string.IsNullOrWhiteSpace(input.NameBox.Text)
                    ? PlayerColorHelper.GetName(input.Color)
                    : input.NameBox.Text.Trim();

                bool isBot = input.BotCheckBox.IsChecked == true;
                players.Add(new PlayerModel(input.Color, name, isBot));
            }

            StartMatchRequested?.Invoke(players);
        }

        private void OnBackClicked(object sender, RoutedEventArgs e) => BackRequested?.Invoke();
    }
}
