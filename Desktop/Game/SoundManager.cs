using System;
using System.IO;
using System.Media;
using System.Threading.Tasks;

namespace PakLudo.Game
{
    public static class SoundManager
    {
        public static bool IsMuted { get; set; } = false;

        private static SoundPlayer? _diceRollPlayer;
        private static SoundPlayer? _tokenStepPlayer;
        private static SoundPlayer? _capturePlayer;
        private static SoundPlayer? _safeStarPlayer;
        private static SoundPlayer? _victoryPlayer;

        static SoundManager()
        {
            try
            {
                _diceRollPlayer = CreatePlayer(GenerateDiceRollWav());
                _tokenStepPlayer = CreatePlayer(GenerateTokenStepWav());
                _capturePlayer = CreatePlayer(GenerateCaptureWav());
                _safeStarPlayer = CreatePlayer(GenerateSafeStarWav());
                _victoryPlayer = CreatePlayer(GenerateVictoryWav());
            }
            catch
            {
                // Fallback gracefully if audio device is unavailable
            }
        }

        private static SoundPlayer? CreatePlayer(byte[] wavBytes)
        {
            var ms = new MemoryStream(wavBytes);
            var player = new SoundPlayer(ms);
            player.LoadAsync();
            return player;
        }

        public static void PlayDiceRoll()
        {
            if (IsMuted) return;
            Task.Run(() => { try { _diceRollPlayer?.Play(); } catch { } });
        }

        public static void PlayTokenStep()
        {
            if (IsMuted) return;
            Task.Run(() => { try { _tokenStepPlayer?.Play(); } catch { } });
        }

        public static void PlayCapture()
        {
            if (IsMuted) return;
            Task.Run(() => { try { _capturePlayer?.Play(); } catch { } });
        }

        public static void PlaySafeStar()
        {
            if (IsMuted) return;
            Task.Run(() => { try { _safeStarPlayer?.Play(); } catch { } });
        }

        public static void PlayVictory()
        {
            if (IsMuted) return;
            Task.Run(() => { try { _victoryPlayer?.Play(); } catch { } });
        }

        #region WAV Synthesis Helpers (Pure C#)

        private static byte[] GenerateDiceRollWav()
        {
            int sampleRate = 22050;
            double duration = 0.15;
            int numSamples = (int)(sampleRate * duration);
            short[] samples = new short[numSamples];
            var rand = new Random(42);

            for (int i = 0; i < numSamples; i++)
            {
                double t = (double)i / sampleRate;
                double env = Math.Exp(-t * 18);
                double rattle = Math.Sin(2 * Math.PI * 180 * t) * (rand.NextDouble() * 2.0 - 1.0);
                double pop = Math.Sin(2 * Math.PI * (350 - t * 800) * t);
                samples[i] = (short)((rattle * 0.6 + pop * 0.4) * env * short.MaxValue * 0.75);
            }
            return BuildWav(samples, sampleRate);
        }

        private static byte[] GenerateTokenStepWav()
        {
            int sampleRate = 22050;
            double duration = 0.08;
            int numSamples = (int)(sampleRate * duration);
            short[] samples = new short[numSamples];

            for (int i = 0; i < numSamples; i++)
            {
                double t = (double)i / sampleRate;
                double env = Math.Exp(-t * 30);
                double freq = 520 + Math.Sin(t * 150) * 120;
                double wave = Math.Sin(2 * Math.PI * freq * t);
                samples[i] = (short)(wave * env * short.MaxValue * 0.7);
            }
            return BuildWav(samples, sampleRate);
        }

        private static byte[] GenerateCaptureWav()
        {
            int sampleRate = 22050;
            double duration = 0.22;
            int numSamples = (int)(sampleRate * duration);
            short[] samples = new short[numSamples];

            for (int i = 0; i < numSamples; i++)
            {
                double t = (double)i / sampleRate;
                double env = Math.Exp(-t * 14);
                double freq = Math.Max(70, 480 - t * 1400);
                double wave = Math.Sin(2 * Math.PI * freq * t) + 0.3 * Math.Sin(2 * Math.PI * (freq * 0.5) * t);
                samples[i] = (short)(Math.Clamp(wave, -1.0, 1.0) * env * short.MaxValue * 0.85);
            }
            return BuildWav(samples, sampleRate);
        }

        private static byte[] GenerateSafeStarWav()
        {
            int sampleRate = 22050;
            double duration = 0.32;
            int numSamples = (int)(sampleRate * duration);
            short[] samples = new short[numSamples];

            for (int i = 0; i < numSamples; i++)
            {
                double t = (double)i / sampleRate;
                double env = Math.Exp(-t * 9);
                double tone1 = Math.Sin(2 * Math.PI * 659.25 * t); // E5
                double tone2 = Math.Sin(2 * Math.PI * 987.77 * t); // B5
                double tone3 = Math.Sin(2 * Math.PI * 1318.51 * t);// E6
                double wave = (tone1 * 0.45 + tone2 * 0.35 + tone3 * 0.2);
                samples[i] = (short)(wave * env * short.MaxValue * 0.75);
            }
            return BuildWav(samples, sampleRate);
        }

        private static byte[] GenerateVictoryWav()
        {
            int sampleRate = 22050;
            double duration = 0.85;
            int numSamples = (int)(sampleRate * duration);
            short[] samples = new short[numSamples];

            for (int i = 0; i < numSamples; i++)
            {
                double t = (double)i / sampleRate;
                double env = t < 0.6 ? 1.0 : Math.Exp(-(t - 0.6) * 7);

                // Fanfare notes (C5 -> E5 -> G5 -> C6)
                double freq = t switch
                {
                    < 0.15 => 523.25, // C5
                    < 0.30 => 659.25, // E5
                    < 0.45 => 783.99, // G5
                    _ => 1046.50      // C6
                };

                double wave = Math.Sin(2 * Math.PI * freq * t) + 0.3 * Math.Sin(2 * Math.PI * freq * 2 * t);
                samples[i] = (short)(wave * env * short.MaxValue * 0.75);
            }
            return BuildWav(samples, sampleRate);
        }

        private static byte[] BuildWav(short[] samples, int sampleRate)
        {
            int byteRate = sampleRate * 2; // 16-bit mono
            int dataSize = samples.Length * 2;
            using var ms = new MemoryStream();
            using var bw = new BinaryWriter(ms);

            bw.Write("RIFF".ToCharArray());
            bw.Write(36 + dataSize);
            bw.Write("WAVE".ToCharArray());
            bw.Write("fmt ".ToCharArray());
            bw.Write(16); // subchunk1 size
            bw.Write((short)1); // PCM
            bw.Write((short)1); // Mono
            bw.Write(sampleRate);
            bw.Write(byteRate);
            bw.Write((short)2); // Block align
            bw.Write((short)16); // Bits per sample
            bw.Write("data".ToCharArray());
            bw.Write(dataSize);

            foreach (var s in samples)
            {
                bw.Write(s);
            }

            return ms.ToArray();
        }

        #endregion
    }
}
