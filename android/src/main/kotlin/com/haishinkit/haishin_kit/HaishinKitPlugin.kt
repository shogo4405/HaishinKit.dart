package com.haishinkit.haishin_kit

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class HaishinKitPlugin : FlutterPlugin, MethodCallHandler {
    companion object {
        private const val CHANNEL_NAME = "com.haishinkit"
        private const val VIEW_TYPE_ID = "plugins.haishinkit.com/netstreamdrawablebiew"
    }

    lateinit var channel: MethodChannel
    lateinit var context: Context

    val rtmpStreamHandler = RtmpStreamHandler(this)
    val rtmpConnectionHandler = RtmpConnectionHandler(this)

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding.platformViewRegistry
            .registerViewFactory(
                VIEW_TYPE_ID,
                FlutterNetStreamDrawableFactory(this, flutterPluginBinding.binaryMessenger)
            )

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method.startsWith("RtmpStream")) {
            rtmpStreamHandler.onMethodCall(call, result)
            return
        }
        if (call.method.startsWith("RtmpConnection")) {
            rtmpConnectionHandler.onMethodCall(call, result)
            return
        }
        when (call.method) {
            "getVersion" -> {
                result.success("0.10.1")
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
