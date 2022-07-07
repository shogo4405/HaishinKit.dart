package com.haishinkit.haishin_kit

import android.os.Build
import androidx.annotation.NonNull
import com.haishinkit.graphics.PixelTransformFactory
import com.haishinkit.vulkan.VkPixelTransform
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class HaishinKitPlugin : FlutterPlugin, MethodCallHandler {
    companion object {
        private const val CHANNEL_NAME = "com.haishinkit"
    }

    lateinit var channel: MethodChannel
    lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    val rtmpStreamHandler = RtmpStreamHandler(this)
    val rtmpConnectionHandler = RtmpConnectionHandler(this)

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
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
                result.success(com.haishinkit.BuildConfig.VERSION_NAME)
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
