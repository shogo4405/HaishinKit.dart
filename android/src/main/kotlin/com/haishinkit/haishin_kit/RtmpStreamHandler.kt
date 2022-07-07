package com.haishinkit.haishin_kit

import com.haishinkit.media.AudioRecordSource
import com.haishinkit.media.Camera2Source
import com.haishinkit.rtmp.RtmpStream
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ConcurrentHashMap

class RtmpStreamHandler(private val plugin: HaishinKitPlugin) : MethodChannel.MethodCallHandler {
    var instances = ConcurrentHashMap<Double, RtmpStream>()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "RtmpStream#create" -> {
                val memory = call.argument<Double>("memory") ?: return;
                val size = instances.size.toDouble()
                plugin.rtmpConnectionHandler.instances[memory]?.let {
                    instances[size] = RtmpStream(
                        it
                    )
                    result.success(size)
                }
            }
            "RtmpStream#setAudioSettings" -> {
                val source = call.argument<Map<String, Any?>>("settings") ?: return
                val stream = instances[call.argument("memory")] ?: return
                (source["bitrate"] as? Int)?.let {
                    stream.audioSetting.bitRate = it
                }
                result.success(null)
            }
            "RtmpStream#setVideoSettings" -> {
                val source = call.argument<Map<String, Any?>>("settings") ?: return
                val stream = instances[call.argument("memory")] ?: return
                (source["width"] as? Int)?.let {
                    stream.videoSetting.width = it
                }
                (source["height"] as? Int)?.let {
                    stream.videoSetting.height = it
                }
                (source["frameInterval"] as? Int)?.let {
                    stream.videoSetting.IFrameInterval = it
                }
                (source["bitrate"] as? Int)?.let {
                    stream.videoSetting.bitRate = it
                }
                result.success(null)
            }
            "RtmpStream#setCaptureSettings" -> {
                result.success(null)
            }
            "RtmpStream#attachAudio" -> {
                val source = call.argument<Map<String, Any?>>("source")
                if (source == null) {
                    instances[call.argument("memory")]?.attachAudio(null)
                } else {
                    instances[call.argument("memory")]?.attachAudio(AudioRecordSource(plugin.context))
                }
                result.success(null)
            }
            "RtmpStream#attachVideo" -> {
                val source = call.argument<Map<String, Any?>>("source")
                if (source == null) {
                    instances[call.argument("memory")]?.attachVideo(null)
                } else {
                    val source = Camera2Source(plugin.context)
                    source.open(0)
                    instances[call.argument("memory")]?.attachVideo(source)
                }
                result.success(null)
            }
            "RtmpStream#registerTexture" -> {
                result.success(0)
            }
            "RtmpStream#publish" -> {
                instances[call.argument("memory")]?.publish(call.argument("name"))
                result.success(null)
            }
        }
    }
}
