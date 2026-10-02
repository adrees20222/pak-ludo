using System.Collections.Generic;
using System.Windows;
using PakLudo.Models;

namespace PakLudo
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            // Setup Navigation Events
            HomeScreenView.PlayClicked += () => ShowScreen(PlayerSetupScreenView);
            HomeScreenView.HowToPlayClicked += () => ShowScreen(HowToPlayScreenView);

            PlayerSetupScreenView.BackRequested += () => ShowScreen(HomeScreenView);
            PlayerSetupScreenView.StartMatchRequested += StartMatch;

            GameScreenView.HomeRequested += () => ShowScreen(HomeScreenView);

            HowToPlayScreenView.BackRequested += () => ShowScreen(HomeScreenView);
        }

        private void StartMatch(List<PlayerModel> players)
        {
            ShowScreen(GameScreenView);
            GameScreenView.StartNewMatch(players);
        }

        private void ShowScreen(FrameworkElement activeScreen)
        {
            HomeScreenView.Visibility = Visibility.Collapsed;
            PlayerSetupScreenView.Visibility = Visibility.Collapsed;
            GameScreenView.Visibility = Visibility.Collapsed;
            HowToPlayScreenView.Visibility = Visibility.Collapsed;

            activeScreen.Visibility = Visibility.Visible;
        }
    }
}
