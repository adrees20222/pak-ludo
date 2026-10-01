package com.adrees.pakludo.pak_ludo

import android.media.AudioAttributes
import android.media.SoundPool
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.adrees.pakludo/audio"
    private var soundPool: SoundPool? = null
    private val soundMap = HashMap<String, Int>()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val audioAttributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_GAME)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        soundPool = SoundPool.Builder()
            .setMaxStreams(8)
            .setAudioAttributes(audioAttributes)
            .build()

        loadSound("step", "assets/audio/step.wav")
        loadSound("dice_roll", "assets/audio/dice_roll.wav")
        loadSound("capture", "assets/audio/capture.wav")
        loadSound("star", "assets/audio/star.wav")
        loadSound("win", "assets/audio/win.wav")

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "playSound" -> {
                    val name = call.argument<String>("name")
                    val volume = call.argument<Double>("volume")?.toFloat() ?: 1.0f
                    val soundId = soundMap[name]
                    if (soundId != null && soundId != 0) {
                        soundPool?.play(soundId, volume, volume, 1, 0, 1.0f)
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun loadSound(name: String, assetPath: String) {
        try {
            val loader = FlutterInjector.instance().flutterLoader()
            val assetKey = loader.getLookupKeyForAsset(assetPath)
            val afd = assets.openFd(assetKey)
            val soundId = soundPool?.load(afd, 1) ?: 0
            soundMap[name] = soundId
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onDestroy() {
        soundPool?.release()
        soundPool = null
        super.onDestroy()
    }
}

