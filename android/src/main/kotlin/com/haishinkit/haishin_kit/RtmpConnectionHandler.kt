package com.haishinkit.haishin_kit

import com.haishinkit.rtmp.RtmpConnection
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ConcurrentHashMap

class RtmpConnectionHandler(private val plugin: HaishinKitPlugin) :
    MethodChannel.MethodCallHandler {
    var instances = ConcurrentHashMap<Int, RtmpConnection>()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "RtmpConnection#create" -> {
                val memory = instances.size
                instances[memory] = RtmpConnection()
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
}
