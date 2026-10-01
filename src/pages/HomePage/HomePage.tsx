import { Link, type MetaFunction } from 'react-router';
import { useEffect } from 'react';
import { useCleanup } from '../../hooks/useCleanup';
import styles from './HomePage.module.css';
import clsx from 'clsx';
import { H } from '../../components/H/H';

export default function HomePage() {
  const cleanup = useCleanup();

  useEffect(() => {
    cleanup();
  }, [cleanup]);

  return (
    <div className={styles.pageContainer}>
      <main className={styles.homePage}>
        <section className={styles.welcome}>
          <h1>
            <span>Welcome to</span> Pak Ludo
          </h1>
          <p>The classic, ad-free Ludo board game with local multiplayer and smart bot opponents</p>
          <nav className={styles.ctaButtons}>
            <Link className={clsx(styles.ctaButton, styles.playNowBtn)} to="/setup">
              <H c="🔥" /> Play Now!
            </Link>
            <Link className={clsx(styles.ctaButton, styles.howToPlayBtn)} to="/how-to-play">
              How to Play
            </Link>
          </nav>
        </section>
        <section className={styles.platformsSection}>
          <h2>
            <H c="🎮" /> Available Everywhere
          </h2>
          <div className={styles.platformGrid}>
            <a
              href="https://pak-ludo.blogspot.com/"
              target="_blank"
              rel="noopener noreferrer"
              className={styles.block}
            >
              <h3>
                <H c="🌐" /> Web Version
              </h3>
              <p>Play directly on Blogger / Browser with full multiplayer & AI bots.</p>
            </a>
            <a
              href="https://chromewebstore.google.com/detail/dmbglbhnkjeknkaiokpafonjbkcimgcb"
              target="_blank"
              rel="noopener noreferrer"
              className={styles.block}
            >
              <h3>
                <H c="🧩" /> Chrome Extension
              </h3>
              <p>Install on Chrome Web Store to play offline in a dedicated tab.</p>
            </a>
            <a
              href="https://github.com/adrees20222/pak-ludo/releases"
              target="_blank"
              rel="noopener noreferrer"
              className={styles.block}
            >
              <h3>
                <H c="📱" /> Android App (APK)
              </h3>
              <p>Download native APK from GitHub Releases for smooth mobile play.</p>
            </a>
            <a
              href="https://github.com/adrees20222/pak-ludo"
              target="_blank"
              rel="noopener noreferrer"
              className={styles.block}
            >
              <h3>
                <H c="⭐" /> GitHub Repository
              </h3>
              <p>Explore open source codebase, stars, and release updates.</p>
            </a>
          </div>
        </section>

        <section className={styles.features}>
          <div className={styles.block}>
            <h3>
              <H c="⚡" /> Instant Play
            </h3>
            <p>No sign-ups. Open the game and jump straight into a match.</p>
          </div>

          <div className={styles.block}>
            <h3>
              <H c="🚫" /> Zero Ads
            </h3>
            <p>No pop-ups, no unskippable videos between turns. Just the pure game.</p>
          </div>
          <div className={styles.block}>
            <h3>
              <H c="🔒" /> 100% Private
            </h3>
            <p>Your game data stays on your device. No accounts, tracking, or ads.</p>
          </div>

          <div className={styles.block}>
            <h3>
              <H c="🤖" /> Smart AI Bots
            </h3>
            <p>Play solo against intelligent computer opponents or pass-and-play with friends.</p>
          </div>
        </section>
      </main>

      <footer className={styles.appFooter}>
        <a href="https://adrees2022.blogspot.com/" target="_blank" rel="noopener noreferrer" className={styles.footerLink}>
          Portfolio
        </a>
        <a href="https://my-extension.blogspot.com/p/support.html" target="_blank" rel="noopener noreferrer" className={styles.footerLink}>
          Support
        </a>
        <a href="https://my-extension.blogspot.com/p/donate.html" target="_blank" rel="noopener noreferrer" className={styles.footerLink}>
          Donate
        </a>
        <a href="https://my-extension.blogspot.com/p/terms.html" target="_blank" rel="noopener noreferrer" className={styles.footerLink}>
          Terms of Services
        </a>
        <a href="https://my-extension.blogspot.com/p/privacy-policy_15.html" target="_blank" rel="noopener noreferrer" className={styles.footerLink}>
          Privacy Policy
        </a>
      </footer>
    </div>
  );
}

export const meta: MetaFunction = () => [{ title: 'Pak Ludo | Classic Board Game' }];
