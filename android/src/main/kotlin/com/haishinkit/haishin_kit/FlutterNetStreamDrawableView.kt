package com.haishinkit.haishin_kit

import android.content.Context
import android.view.View
import com.haishinkit.view.HkTextureView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class FlutterNetStreamDrawableView(
    context: Context?,
    messenger: BinaryMessenger,
    id: Int,
    private val plugin: HaishinKitPlugin
) : PlatformView, MethodChannel.MethodCallHandler {
    private val textureView = HkTextureView(context!!)

    init {
        MethodChannel(messenger, "plugins.haishinkit.com/view_$id").also {
            it.setMethodCallHandler(this)
        }
    }

    override fun getView(): View = textureView

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "attachStream" -> {
                val memory = call.argument<Double>("memory")
                textureView.attachStream(plugin.rtmpStreamHandler.instances[memory])
            }
            else -> result.notImplemented()
        }
    }

    override fun dispose() {
    }
}
