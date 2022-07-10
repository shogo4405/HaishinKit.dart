package com.haishinkit.haishin_kit

import android.util.Size
import com.haishinkit.event.Event
import com.haishinkit.event.IEventListener
import com.haishinkit.media.AudioRecordSource
import com.haishinkit.media.Camera2Source
import com.haishinkit.rtmp.RtmpStream
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class RtmpStreamHandler(
    private val plugin: HaishinKitPlugin,
    private val id: Int,
    handler: RtmpConnectionHandler?
) : MethodChannel.MethodCallHandler, IEventListener,
    EventChannel.StreamHandler {
    companion object {
        private const val TAG = "RtmpStream"
    }

    var instance: RtmpStream? = null
    private var channel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    init {
        handler?.instance?.let {
            instance = RtmpStream(it)
        }
        channel = EventChannel(
            plugin.flutterPluginBinding.binaryMessenger,
            "com.haishinkit.eventchannel/${id}"
        )
        channel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
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
                result.success(null)
            }
            "$TAG#setCaptureSettings" -> {
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
                } else {
                    val source = Camera2Source(plugin.flutterPluginBinding.applicationContext)
                    source.open(0)
                    instance?.attachVideo(source)
                }
                result.success(null)
            }
            "$TAG#registerTexture" -> {
                val netStream = instance
                if (netStream?.drawable == null) {
                    val texture = NetStreamDrawableTexture(plugin.flutterPluginBinding)
                    texture.attachStream(netStream)
                    result.success(texture.id)
                } else {
                    val texture = (netStream.drawable as? NetStreamDrawableTexture)
                    val width = call.argument<Double>("width") ?: 0
                    val height = call.argument<Double>("height") ?: 0
                    texture?.imageExtent =
                        Size(width.toInt(), height.toInt())
                    result.success(texture?.id)
                }
            }
            "$TAG#publish" -> {
                instance?.publish(call.argument("name"))
                result.success(null)
            }
            "$TAG#dispose" -> {
                eventSink?.endOfStream()
                instance = null
                plugin.onDispose(id)
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
