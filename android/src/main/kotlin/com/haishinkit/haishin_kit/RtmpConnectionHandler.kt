package com.haishinkit.haishin_kit

import android.os.Handler
import android.os.Looper
import com.haishinkit.event.Event
import com.haishinkit.event.IEventListener
import com.haishinkit.rtmp.RtmpConnection
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class RtmpConnectionHandler(
    private val plugin: HaishinKitPlugin,
    private val id: Int,
) : MethodChannel.MethodCallHandler, IEventListener,
    EventChannel.StreamHandler {
    companion object {
        private const val TAG = "RtmpConnection"
    }

    var instance: RtmpConnection? = RtmpConnection()
        private set

    private var channel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    init {
        instance?.addEventListener(Event.RTMP_STATUS, this)
        channel = EventChannel(
            plugin.flutterPluginBinding.binaryMessenger,
            "com.haishinkit.eventchannel/${id}"
        )
        channel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "$TAG#connect" -> {
                val command = call.argument<String>("command") ?: ""
                instance?.connect(command)
                result.success(null)
            }
            "$TAG#close" -> {
                instance?.close()
                result.success(null)
            }
            "$TAG#dispose" -> {
                eventSink?.endOfStream()
                instance?.dispose()
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
