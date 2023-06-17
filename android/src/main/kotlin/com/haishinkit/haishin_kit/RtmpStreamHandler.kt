package com.haishinkit.haishin_kit

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.media.MediaFormat.KEY_LEVEL
import android.media.MediaFormat.KEY_PROFILE
import android.os.Handler
import android.util.Size
import android.view.WindowManager
import com.haishinkit.codec.CodecOption
import com.haishinkit.event.Event
import com.haishinkit.event.IEventListener
import com.haishinkit.haishinkit.ProfileLevel
import com.haishinkit.media.AudioRecordSource
import com.haishinkit.media.Camera2Source
import com.haishinkit.rtmp.RtmpStream
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

class RtmpStreamHandler(
    private val plugin: HaishinKitPlugin, handler: RtmpConnectionHandler?
) : MethodChannel.MethodCallHandler, IEventListener, EventChannel.StreamHandler {
    companion object {
        private const val TAG = "RtmpStream"
    }

    private var instance: RtmpStream? = null
        set(value) {
            field?.dispose()
            field = value
        }
    private var channel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var camera: Camera2Source? = null
        set(value) {
            field?.close()
            field = value
        }

    init {
        handler?.instance?.let {
            instance = RtmpStream(it)
        }
        channel = EventChannel(
            plugin.flutterPluginBinding.binaryMessenger, "com.haishinkit.eventchannel/${hashCode()}"
        )
        channel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "$TAG#getHasAudio" -> {
                result.success(instance?.audioSetting?.muted)
            }

            "$TAG#setHasAudio" -> {
                val value = call.argument<Boolean?>("value")
                value?.let {
                    instance?.audioSetting?.muted = !it
                }
                result.success(null)
            }

            "$TAG#getHasVideo" -> {
                result.success(null)
            }

            "$TAG#setHasVideo" -> {
                result.success(null)
            }

            "$TAG#setFrameRate" -> {
                val value = call.argument<Int?>("value")
                value?.let {
                    instance?.videoSetting?.frameRate = it
                }
                result.success(null)
            }

            "$TAG#setSessionPreset" -> {
                // for iOS
                result.success(null)
            }

            "$TAG#setAudioSettings" -> {
                val source = call.argument<Map<String, Any?>>("settings") ?: return
                (source["bitrate"] as? Int)?.let {
                    instance?.audioSetting?.bitRate = it
                }
                result.success(null)
            }

            "$TAG#setVideoSettings" -> {
                val source = call.argument<Map<String, Any?>>("settings") ?: return
                (source["width"] as? Int)?.let {
                    instance?.videoSetting?.width = it
                }
                (source["height"] as? Int)?.let {
                    instance?.videoSetting?.height = it
                }
                (source["frameInterval"] as? Int)?.let {
                    instance?.videoSetting?.IFrameInterval = it
                }
                (source["bitrate"] as? Int)?.let {
                    instance?.videoSetting?.bitRate = it
                }
                (source["profileLevel"] as? String)?.let {
                    try {
                        val profileLevel = ProfileLevel.valueOf(it)
                        var options = mutableListOf<CodecOption>()
                        options.add(CodecOption(KEY_PROFILE, profileLevel.profile))
                        options.add(CodecOption(KEY_LEVEL, profileLevel.level))
                        instance?.videoSetting?.options = options
                    } catch (ignored: Exception) {
                        // Do nothing, use default setting
                    }
                }
                result.success(null)
            }

            "$TAG#attachAudio" -> {
                val source = call.argument<Map<String, Any?>>("source")
                if (source == null) {
                    instance?.attachAudio(null)
                } else {
                    instance?.attachAudio(AudioRecordSource(plugin.flutterPluginBinding.applicationContext))
                }
                result.success(null)
            }

            "$TAG#attachVideo" -> {
                val source = call.argument<Map<String, Any?>>("source")
                if (source == null) {
                    instance?.attachVideo(null)
                    camera = null
                } else {
                    var facing = 0
                    when (source["position"]) {
                        "front" -> {
                            facing = CameraCharacteristics.LENS_FACING_FRONT
                        }

                        "back" -> {
                            facing = CameraCharacteristics.LENS_FACING_BACK
                        }
                    }
                    camera = Camera2Source(plugin.flutterPluginBinding.applicationContext)
                    camera?.let {
                        instance?.attachVideo(camera)
                    }
                    val handler = Handler()
                    handler.postDelayed({
                        if (instance?.drawable != null) {
                            camera?.open(facing)
                        }
                    }, 750)
                }
                result.success(null)
            }

            "$TAG#registerTexture" -> {
                val netStream = instance
                if (netStream?.drawable == null) {
                    val texture = NetStreamDrawableTexture(plugin.flutterPluginBinding)
                    texture.attachStream(netStream)
                    if (camera?.stream != null) {
                        camera?.open()
                    }
                    result.success(texture.id)
                } else {
                    val texture = (netStream.drawable as? NetStreamDrawableTexture)
                    val width = call.argument<Double>("width") ?: 0
                    val height = call.argument<Double>("height") ?: 0
                    texture?.imageExtent = Size(width.toInt(), height.toInt())
                    (plugin.flutterPluginBinding.applicationContext.getSystemService(Context.WINDOW_SERVICE) as? WindowManager)?.defaultDisplay?.orientation?.let {
                        netStream.deviceOrientation = it
                    }
                    result.success(texture?.id)
                }
            }

            "$TAG#publish" -> {
                instance?.publish(call.argument("name"))
                result.success(null)
            }

            "$TAG#play" -> {
                val name = call.argument<String>("name")
                if (name != null) {
                    instance?.play(name)
                }
                result.success(null)
            }

            "$TAG#close" -> {
                instance?.close()
                result.success(null)
            }

            "$TAG#dispose" -> {
                eventSink?.endOfStream()
                instance?.close()
                camera?.close()
                instance?.dispose()
                instance = null
                camera = null
                plugin.onDispose(hashCode())
                result.success(null)
            }
        }
    }

    override fun handleEvent(event: Event) {
        val map = HashMap<String, Any?>()
        map["type"] = event.type
        map["data"] = event.data
        plugin.uiThreadHandler.post {
            eventSink?.success(map)
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
    }
}
