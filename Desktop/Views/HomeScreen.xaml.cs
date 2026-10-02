using System;
using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace PakLudo.Views
{
    public partial class HomeScreen : UserControl
    {
        public event Action? PlayClicked;
        public event Action? HowToPlayClicked;

        public HomeScreen()
        {
            InitializeComponent();
        }

        private void OnPlayClicked(object sender, RoutedEventArgs e) => PlayClicked?.Invoke();
        private void OnHowToPlayClicked(object sender, RoutedEventArgs e) => HowToPlayClicked?.Invoke();

        private void OpenUrl(string url)
        {
            try
            {
                Process.Start(new ProcessStartInfo(url) { UseShellExecute = true });
            }
            catch { }
        }

        private void OnWebClicked(object sender, MouseButtonEventArgs e) => OpenUrl("https://pak-ludo.blogspot.com/");
        private void OnExtensionClicked(object sender, MouseButtonEventArgs e) => OpenUrl("https://chromewebstore.google.com/detail/dmbglbhnkjeknkaiokpafonjbkcimgcb");
        private void OnAndroidClicked(object sender, MouseButtonEventArgs e) => OpenUrl("https://github.com/adrees20222/pak-ludo/releases");
        private void OnGitHubClicked(object sender, MouseButtonEventArgs e) => OpenUrl("https://github.com/adrees20222/pak-ludo");

        private void OnPortfolioClicked(object sender, MouseButtonEventArgs e) => OpenUrl("https://adrees2022.blogspot.com/");
        private void OnSupportClicked(object sender, MouseButtonEventArgs e) => OpenUrl("https://my-extension.blogspot.com/p/support.html");
        private void OnDonateClicked(object sender, MouseButtonEventArgs e) => OpenUrl("https://my-extension.blogspot.com/p/donate.html");
        private void OnTermsClicked(object sender, MouseButtonEventArgs e) => OpenUrl("https://my-extension.blogspot.com/p/terms.html");
        private void OnPrivacyClicked(object sender, MouseButtonEventArgs e) => OpenUrl("https://my-extension.blogspot.com/p/privacy-policy_15.html");
    }
}
