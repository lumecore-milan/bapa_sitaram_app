/*package com.bapasitaram.bapa_sitaram

import android.media.MediaPlayer
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity(){
    private val CHANNEL = "flutter.myapp.app/myChannel"
    private var mediaPlayer: MediaPlayer? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "playSound" -> {
                        val assetPath = call.argument<String>("path") ?: ""
                        playRingtone(assetPath)
                        result.success(null)
                    }
                    "stopRingtone" -> {
                        stopRingtone()
                        result.success(null)
                    }
                    "notificationReceived"-> {
                    Log.d("message","Notification received method call")
                    val data = call.arguments
                    Handler(Looper.getMainLooper()).post {
                        channel.invokeMethod("notificationToDart", data)
                    }
                    //  channel.invokeMethod("notificationToDart", data)
                }"notificationClick"-> {
                    Log.d("message","Notification click received method call")
                    val data = call.arguments
                    Handler(Looper.getMainLooper()).post {
                        channel.invokeMethod("notificationToDart", data)
                    }
                }"getDownloadDirectory"-> {
                    val path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).path
                    result.success(path)
                }
                    else -> result.notImplemented()
                }
            }
    }
    private fun playRingtone(assetPath: String) {
        stopRingtone()

        try {
            val afd = assets.openFd(assetPath)
            mediaPlayer = MediaPlayer().apply {
                setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
                isLooping = true
                prepare()
                start()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun stopRingtone() {
        mediaPlayer?.stop()
        mediaPlayer?.release()
        mediaPlayer = null
    }
}
*/