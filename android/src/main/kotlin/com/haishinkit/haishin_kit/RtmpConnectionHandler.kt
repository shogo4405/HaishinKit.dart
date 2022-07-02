package com.haishinkit.haishin_kit

import com.haishinkit.event.Event
import com.haishinkit.event.IEventListener
import com.haishinkit.rtmp.RtmpConnection
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ConcurrentHashMap

class RtmpConnectionHandler(private val plugin: HaishinKitPlugin) : MethodChannel.MethodCallHandler,
    IEventListener {
    var instances = ConcurrentHashMap<Double, RtmpConnection>()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "RtmpConnection#create" -> {
                val memory = instances.size.toDouble()
                instances[memory] = RtmpConnection()
                instances[memory]?.addEventListener(Event.RTMP_STATUS, this)
                instances[memory]?.addEventListener(Event.IO_ERROR, this)
                result.success(memory)
            }
            "RtmpConnection#connect" -> {
                val command = call.argument<String>("command") ?: ""
                instances[call.argument("memory")]?.connect(command)
            }
            "RtmpConnection#close" -> {
                instances[call.argument("memory")]?.close();
            }
        }
    }

    override fun handleEvent(event: Event) {
    }
}
