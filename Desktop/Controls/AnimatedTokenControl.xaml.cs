using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using PakLudo.Models;

namespace PakLudo.Controls
{
    public partial class AnimatedTokenControl : UserControl
    {
        public TokenModel? Token { get; private set; }
        public event Action<TokenModel>? TokenClicked;
        private Storyboard? _pulseAnimation;

        public AnimatedTokenControl()
        {
            InitializeComponent();
            _pulseAnimation = TryFindResource("PulseAnimation") as Storyboard;
        }

        public void BindToken(TokenModel token, double size)
        {
            Token = token;
            Width = size;
            Height = size;
            RootGrid.Width = size;
            RootGrid.Height = size;
            InnerCore.Width = size * 0.38;
            InnerCore.Height = size * 0.38;

            var brush = PlayerColorHelper.GetBrush(token.Color);
            BodyEllipse.Fill = brush;

            UpdateMovableState(token.IsMovable);
        }

        public void UpdateMovableState(bool isMovable)
        {
            if (isMovable)
            {
                Cursor = Cursors.Hand;
                OuterGlow.Visibility = Visibility.Visible;
                _pulseAnimation?.Begin(this, true);
            }
            else
            {
                Cursor = Cursors.Arrow;
                OuterGlow.Visibility = Visibility.Collapsed;
                _pulseAnimation?.Stop(this);
            }
        }

        private void OnTokenClicked(object sender, MouseButtonEventArgs e)
        {
            if (Token != null && Token.IsMovable)
            {
                TokenClicked?.Invoke(Token);
            }
        }
    }
}
