using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using PakLudo.Models;

namespace PakLudo.Controls
{
    public partial class VictoryDialog : UserControl
    {
        public event Action? PlayAgainClicked;
        public event Action? HomeClicked;

        public VictoryDialog()
        {
            InitializeComponent();
        }

        public void SetWinners(List<PlayerModel> winners)
        {
            StandingsContainer.Children.Clear();

            string[] medals = { "🥇", "🥈", "🥉", "🏅" };

            for (int i = 0; i < winners.Count; i++)
            {
                var p = winners[i];
                string medal = i < medals.Length ? medals[i] : "🏅";

                var card = new Border
                {
                    Background = PlayerColorHelper.GetBaseBrush(p.Color),
                    BorderBrush = PlayerColorHelper.GetBrush(p.Color),
                    BorderThickness = new Thickness(1.5),
                    CornerRadius = new CornerRadius(10),
                    Padding = new Thickness(14, 10, 14, 10),
                    Margin = new Thickness(0, 0, 0, 8)
                };

                var grid = new Grid();
                grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(40) });
                grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
                grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

                var medalText = new TextBlock
                {
                    Text = medal,
                    FontSize = 22,
                    VerticalAlignment = VerticalAlignment.Center
                };
                Grid.SetColumn(medalText, 0);

                var nameStack = new StackPanel { Orientation = Orientation.Horizontal, VerticalAlignment = VerticalAlignment.Center };
                var nameText = new TextBlock
                {
                    Text = p.Name,
                    FontWeight = FontWeights.Bold,
                    FontSize = 16,
                    Foreground = new SolidColorBrush(Color.FromRgb(15, 23, 42)),
                    Margin = new Thickness(0, 0, 8, 0)
                };
                nameStack.Children.Add(nameText);

                if (p.IsBot)
                {
                    var botBadge = new Border
                    {
                        Background = new SolidColorBrush(Color.FromRgb(226, 232, 240)),
                        CornerRadius = new CornerRadius(4),
                        Padding = new Thickness(6, 2, 6, 2),
                        Child = new TextBlock
                        {
                            Text = "BOT",
                            FontSize = 11,
                            FontWeight = FontWeights.Bold,
                            Foreground = new SolidColorBrush(Color.FromRgb(71, 85, 105))
                        }
                    };
                    nameStack.Children.Add(botBadge);
                }
                Grid.SetColumn(nameStack, 1);

                var rankText = new TextBlock
                {
                    Text = $"Rank #{i + 1}",
                    FontWeight = FontWeights.SemiBold,
                    FontSize = 14,
                    Foreground = PlayerColorHelper.GetBrush(p.Color),
                    VerticalAlignment = VerticalAlignment.Center
                };
                Grid.SetColumn(rankText, 2);

                grid.Children.Add(medalText);
                grid.Children.Add(nameStack);
                grid.Children.Add(rankText);

                card.Child = grid;
                StandingsContainer.Children.Add(card);
            }
        }

        private void OnPlayAgainClicked(object sender, RoutedEventArgs e) => PlayAgainClicked?.Invoke();
        private void OnHomeClicked(object sender, RoutedEventArgs e) => HomeClicked?.Invoke();
    }
}
