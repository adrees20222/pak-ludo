using System;
using System.Windows;
using System.Windows.Controls;

namespace PakLudo.Views
{
    public partial class HowToPlayScreen : UserControl
    {
        public event Action? BackRequested;

        public HowToPlayScreen()
        {
            InitializeComponent();
        }

        private void OnBackClicked(object sender, RoutedEventArgs e) => BackRequested?.Invoke();
    }
}
