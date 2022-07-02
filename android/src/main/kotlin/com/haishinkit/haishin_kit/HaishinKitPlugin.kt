package com.haishinkit.haishin_kit

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.haishinkit.rtmp.RtmpConnection
import com.haishinkit.rtmp.RtmpStream
import java.util.concurrent.ConcurrentHashMap

class HaishinKitPlugin: FlutterPlugin, MethodCallHandler {
  lateinit var channel : MethodChannel
  lateinit var context: Context

  val rtmpStreamHandler = RtmpStreamHandler(this)
  val rtmpConnectionHandler = RtmpConnectionHandler(this)

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.haishinkit")
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
        result.success("0.10.0")
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
