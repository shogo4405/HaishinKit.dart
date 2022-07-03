package com.haishinkit.haishin_kit

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class FlutterNetStreamDrawableFactory(
    private val plugin: HaishinKitPlugin,
    private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView =
        FlutterNetStreamDrawableView(context, messenger, viewId, plugin)
}
