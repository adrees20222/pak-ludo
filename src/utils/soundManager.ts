/**
 * Sound Manager for Pak Ludo
 * Synthesizes dynamic, zero-latency sound effects using Web Audio API
 * and handles persistent mute state and haptic feedback.
 */

class SoundManager {
  private ctx: AudioContext | null = null;
  private isMuted: boolean = false;
  private listeners: Set<(muted: boolean) => void> = new Set();

  constructor() {
    if (typeof window !== 'undefined') {
      const savedMute = localStorage.getItem('pak-ludo-muted');
      this.isMuted = savedMute === 'true';
    }
  }

  private initContext() {
    if (!this.ctx && typeof window !== 'undefined') {
      const AudioCtx = window.AudioContext || (window as unknown as { webkitAudioContext: typeof AudioContext }).webkitAudioContext;
      if (AudioCtx) {
        this.ctx = new AudioCtx();
      }
    }
    if (this.ctx && this.ctx.state === 'suspended') {
      this.ctx.resume().catch(() => {});
    }
  }

  public getIsMuted(): boolean {
    return this.isMuted;
  }

  public setMuted(muted: boolean) {
    this.isMuted = muted;
    if (typeof window !== 'undefined') {
      localStorage.setItem('pak-ludo-muted', String(muted));
    }
    this.listeners.forEach((listener) => listener(this.isMuted));
  }

  public toggleMute(): boolean {
    this.setMuted(!this.isMuted);
    return this.isMuted;
  }

  public subscribe(listener: (muted: boolean) => void): () => void {
    this.listeners.add(listener);
    return () => this.listeners.delete(listener);
  }

  public vibrate(pattern: number | number[] = 40) {
    if (this.isMuted) return;
    try {
      if (typeof navigator !== 'undefined' && navigator.vibrate) {
        navigator.vibrate(pattern);
      }
    } catch {
      // Ignore vibration errors
    }
  }

  /**
   * 🎲 Dice Roll Sound: Procedural rattling & tumble
   */
  public playDiceRoll() {
    if (this.isMuted) return;
    this.initContext();
    if (!this.ctx) return;
    this.vibrate([20, 30, 20]);

    const ctx = this.ctx;
    const now = ctx.currentTime;
    const rattleCount = 6;
    const interval = 0.1;

    for (let i = 0; i < rattleCount; i++) {
      const time = now + i * interval + (Math.random() * 0.03 - 0.015);
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();

      osc.type = 'triangle';
      // Varying pitch to simulate dice tumbling against surface
      osc.frequency.setValueAtTime(140 + Math.random() * 120, time);
      osc.frequency.exponentialRampToValueAtTime(60, time + 0.07);

      gain.gain.setValueAtTime(0.3, time);
      gain.gain.exponentialRampToValueAtTime(0.001, time + 0.07);

      osc.connect(gain);
      gain.connect(ctx.destination);

      osc.start(time);
      osc.stop(time + 0.07);
    }
  }

  /**
   * 🚶 Token Step / Tick: Crisp bubble pop sound per tile
   */
  public playTokenStep() {
    if (this.isMuted) return;
    this.initContext();
    if (!this.ctx) return;
    this.vibrate(15);

    const ctx = this.ctx;
    const now = ctx.currentTime;

    const osc = ctx.createOscillator();
    const gain = ctx.createGain();

    osc.type = 'sine';
    osc.frequency.setValueAtTime(480, now);
    osc.frequency.exponentialRampToValueAtTime(220, now + 0.05);

    gain.gain.setValueAtTime(0.25, now);
    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.05);

    osc.connect(gain);
    gain.connect(ctx.destination);

    osc.start(now);
    osc.stop(now + 0.05);
  }

  /**
   * 💥 Dramatic Capture Sound: Slide down + heavy punch impact
   */
  public playCapture() {
    if (this.isMuted) return;
    this.initContext();
    if (!this.ctx) return;
    this.vibrate([60, 50, 100]);

    const ctx = this.ctx;
    const now = ctx.currentTime;

    // 1. Descending slide
    const slideOsc = ctx.createOscillator();
    const slideGain = ctx.createGain();
    slideOsc.type = 'sawtooth';
    slideOsc.frequency.setValueAtTime(600, now);
    slideOsc.frequency.exponentialRampToValueAtTime(90, now + 0.25);

    slideGain.gain.setValueAtTime(0.35, now);
    slideGain.gain.exponentialRampToValueAtTime(0.001, now + 0.25);

    slideOsc.connect(slideGain);
    slideGain.connect(ctx.destination);
    slideOsc.start(now);
    slideOsc.stop(now + 0.25);

    // 2. Punchy impact thump
    const impactOsc = ctx.createOscillator();
    const impactGain = ctx.createGain();
    impactOsc.type = 'triangle';
    impactOsc.frequency.setValueAtTime(160, now + 0.05);
    impactOsc.frequency.exponentialRampToValueAtTime(30, now + 0.35);

    impactGain.gain.setValueAtTime(0.5, now + 0.05);
    impactGain.gain.exponentialRampToValueAtTime(0.001, now + 0.35);

    impactOsc.connect(impactGain);
    impactGain.connect(ctx.destination);
    impactOsc.start(now + 0.05);
    impactOsc.stop(now + 0.35);
  }

  /**
   * ⭐ Safe Star Landing Chime: Sparkling harmonious bell arpeggio
   */
  public playSafeSpot() {
    if (this.isMuted) return;
    this.initContext();
    if (!this.ctx) return;
    this.vibrate([30, 40, 30]);

    const ctx = this.ctx;
    const now = ctx.currentTime;
    const notes = [659.25, 830.61, 987.77, 1318.51]; // E5, G#5, B5, E6

    notes.forEach((freq, index) => {
      const noteTime = now + index * 0.08;
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();

      osc.type = 'sine';
      osc.frequency.setValueAtTime(freq, noteTime);

      gain.gain.setValueAtTime(0.25, noteTime);
      gain.gain.exponentialRampToValueAtTime(0.001, noteTime + 0.4);

      osc.connect(gain);
      gain.connect(ctx.destination);

      osc.start(noteTime);
      osc.stop(noteTime + 0.4);
    });
  }

  /**
   * 🏆 Victory Fanfare: Triumphant brass sequence
   */
  public playVictory() {
    if (this.isMuted) return;
    this.initContext();
    if (!this.ctx) return;
    this.vibrate([100, 50, 100, 50, 200]);

    const ctx = this.ctx;
    const now = ctx.currentTime;

    // Victory melody: G4 -> C5 -> E5 -> G5 -> C6
    const fanfareNotes = [
      { freq: 392.0, duration: 0.15, offset: 0 },
      { freq: 523.25, duration: 0.15, offset: 0.15 },
      { freq: 659.25, duration: 0.15, offset: 0.3 },
      { freq: 783.99, duration: 0.35, offset: 0.45 },
      { freq: 1046.5, duration: 0.8, offset: 0.8 },
    ];

    fanfareNotes.forEach(({ freq, duration, offset }) => {
      const noteTime = now + offset;
      const osc = ctx.createOscillator();
      const gain = ctx.createGain();

      osc.type = 'triangle';
      osc.frequency.setValueAtTime(freq, noteTime);

      gain.gain.setValueAtTime(0.35, noteTime);
      gain.gain.exponentialRampToValueAtTime(0.001, noteTime + duration);

      osc.connect(gain);
      gain.connect(ctx.destination);

      osc.start(noteTime);
      osc.stop(noteTime + duration);
    });
  }
}

export const soundManager = new SoundManager();
