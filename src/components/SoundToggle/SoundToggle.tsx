import React, { useState, useEffect } from 'react';
import { soundManager } from '../../utils/soundManager';
import styles from './SoundToggle.module.css';

export function SoundToggle() {
  const [isMuted, setIsMuted] = useState(soundManager.getIsMuted());

  useEffect(() => {
    const unsubscribe = soundManager.subscribe((muted) => {
      setIsMuted(muted);
    });
    return unsubscribe;
  }, []);

  const toggle = () => {
    soundManager.toggleMute();
  };

  return (
    <button
      type="button"
      className={`${styles.soundToggleBtn} ${isMuted ? styles.muted : ''}`}
      onClick={toggle}
      title={isMuted ? 'Unmute Sound Effects' : 'Mute Sound Effects'}
      aria-label={isMuted ? 'Unmute Sound Effects' : 'Mute Sound Effects'}
    >
      {isMuted ? (
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
          <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
          <line x1="23" y1="9" x2="17" y2="15"></line>
          <line x1="17" y1="9" x2="23" y2="15"></line>
        </svg>
      ) : (
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
          <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon>
          <path d="M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07"></path>
        </svg>
      )}
    </button>
  );
}
