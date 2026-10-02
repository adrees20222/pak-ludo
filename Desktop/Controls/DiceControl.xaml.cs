using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Animation;
using PakLudo.Models;

namespace PakLudo.Controls
{
    public partial class DiceControl : UserControl
    {
        public event Action? DiceClicked;
        private Storyboard? _rollAnimation;

        public DiceControl()
        {
            InitializeComponent();
            _rollAnimation = TryFindResource("RollShakeAnimation") as Storyboard;
        }

        public void SetPlayerColor(PlayerColor color)
        {
            var brush = PlayerColorHelper.GetBrush(color);
            DiceBorder.BorderBrush = brush;
            Pip_TL.Fill = brush;
            Pip_TR.Fill = brush;
            Pip_ML.Fill = brush;
            Pip_MC.Fill = brush;
            Pip_MR.Fill = brush;
            Pip_BL.Fill = brush;
            Pip_BR.Fill = brush;
            PromptText.Foreground = brush;
        }

        public void SetValue(int? value, bool isRolling, bool isMovable)
        {
            if (isRolling)
            {
                PromptText.Visibility = Visibility.Collapsed;
                _rollAnimation?.Begin(this, true);
                HideAllPips();
                Pip_MC.Visibility = Visibility.Visible;
                return;
            }

            _rollAnimation?.Stop(this);

            if (!value.HasValue)
            {
                PromptText.Text = "ROLL";
                PromptText.Visibility = Visibility.Visible;
                HideAllPips();
                return;
            }

            PromptText.Visibility = Visibility.Collapsed;
            HideAllPips();

            switch (value.Value)
            {
                case 1:
                    Pip_MC.Visibility = Visibility.Visible;
                    break;
                case 2:
                    Pip_TL.Visibility = Visibility.Visible;
                    Pip_BR.Visibility = Visibility.Visible;
                    break;
                case 3:
                    Pip_TL.Visibility = Visibility.Visible;
                    Pip_MC.Visibility = Visibility.Visible;
                    Pip_BR.Visibility = Visibility.Visible;
                    break;
                case 4:
                    Pip_TL.Visibility = Visibility.Visible;
                    Pip_TR.Visibility = Visibility.Visible;
                    Pip_BL.Visibility = Visibility.Visible;
                    Pip_BR.Visibility = Visibility.Visible;
                    break;
                case 5:
                    Pip_TL.Visibility = Visibility.Visible;
                    Pip_TR.Visibility = Visibility.Visible;
                    Pip_MC.Visibility = Visibility.Visible;
                    Pip_BL.Visibility = Visibility.Visible;
                    Pip_BR.Visibility = Visibility.Visible;
                    break;
                case 6:
                    Pip_TL.Visibility = Visibility.Visible;
                    Pip_TR.Visibility = Visibility.Visible;
                    Pip_ML.Visibility = Visibility.Visible;
                    Pip_MR.Visibility = Visibility.Visible;
                    Pip_BL.Visibility = Visibility.Visible;
                    Pip_BR.Visibility = Visibility.Visible;
                    break;
            }
        }

        private void HideAllPips()
        {
            Pip_TL.Visibility = Visibility.Collapsed;
            Pip_TR.Visibility = Visibility.Collapsed;
            Pip_ML.Visibility = Visibility.Collapsed;
            Pip_MC.Visibility = Visibility.Collapsed;
            Pip_MR.Visibility = Visibility.Collapsed;
            Pip_BL.Visibility = Visibility.Collapsed;
            Pip_BR.Visibility = Visibility.Collapsed;
        }

        private void OnDiceClicked(object sender, RoutedEventArgs e)
        {
            DiceClicked?.Invoke();
        }
    }
}
