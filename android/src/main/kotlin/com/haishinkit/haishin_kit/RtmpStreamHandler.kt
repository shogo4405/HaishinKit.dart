package com.haishinkit.haishin_kit

import com.haishinkit.event.Event
import com.haishinkit.event.IEventListener
import com.haishinkit.media.AudioRecordSource
import com.haishinkit.media.Camera2Source
import com.haishinkit.rtmp.RtmpStream
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ConcurrentHashMap

class RtmpStreamHandler(private val plugin: HaishinKitPlugin) : MethodChannel.MethodCallHandler, IEventListener {
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
                    instances[size]?.addEventListener(Event.RTMP_STATUS, this)
                    instances[size]?.addEventListener(Event.IO_ERROR, this)
                    result.success(size)
                }
            }
            "RtmpStream#attachAudio" -> {
                val source = call.argument<Map<String, Any?>>("source")
                if (source == null) {
                    instances[call.argument("memory")]?.attachAudio(null)
                } else {
                    instances[call.argument("memory")]?.attachAudio(AudioRecordSource())
                }
            }
            "RtmpStream#attachVideo" -> {
                val source = call.argument<Map<String, Any?>>("source")
                if (source == null) {
                    instances[call.argument("memory")]?.attachVideo(null)
                } else {
                    instances[call.argument("memory")]?.attachVideo(Camera2Source(plugin.context))
                }
            }
            "RtmpStream#publish" -> {
                instances[call.argument("memory")]?.publish(call.argument("name"))
            }
        }
    }

    override fun handleEvent(event: Event) {
    }
}
