import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundService {
  static final SoundService instance = SoundService._();
  SoundService._();

  static const MethodChannel _channel = MethodChannel('com.adrees.pakludo/audio');

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isMuted = prefs.getBool('pak_ludo_muted') ?? false;
    } catch (_) {}
  }

  Future<void> setMuted(bool muted) async {
    _isMuted = muted;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pak_ludo_muted', muted);
    } catch (_) {}
  }

  Future<void> toggleMute() async {
    await setMuted(!_isMuted);
  }

  Future<void> _playSound(String name, {double volume = 1.0}) async {
    if (_isMuted) return;
    try {
      await _channel.invokeMethod('playSound', {
        'name': name,
        'volume': volume,
      });
    } catch (_) {
      // Fallback to system sound if not on Android
      SystemSound.play(SystemSoundType.click);
    }
  }

  void playDiceRoll() {
    if (_isMuted) return;
    HapticFeedback.mediumImpact();
    _playSound('dice_roll', volume: 0.95);
  }

  void playTokenStep() {
    if (_isMuted) return;
    HapticFeedback.lightImpact();
    _playSound('step', volume: 0.85);
  }

  void playCapture() {
    if (_isMuted) return;
    HapticFeedback.heavyImpact();
    _playSound('capture', volume: 1.0);
  }

  void playSafeSpot() {
    if (_isMuted) return;
    HapticFeedback.mediumImpact();
    _playSound('star', volume: 0.9);
  }

  void playVictory() {
    if (_isMuted) return;
    HapticFeedback.heavyImpact();
    _playSound('win', volume: 1.0);
  }
}


