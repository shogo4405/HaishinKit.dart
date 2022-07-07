package com.haishinkit.haishin_kit

import android.content.Context
import android.graphics.Bitmap
import android.util.Log
import android.util.Size
import android.view.Surface
import android.view.WindowManager
import com.haishinkit.graphics.ImageOrientation
import com.haishinkit.graphics.PixelTransform
import com.haishinkit.graphics.PixelTransformFactory
import com.haishinkit.graphics.VideoGravity
import com.haishinkit.graphics.effect.VideoEffect
import com.haishinkit.net.NetStream
import com.haishinkit.view.NetStreamDrawable
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.view.TextureRegistry

class NetStreamDrawableTexture(binding: FlutterPlugin.FlutterPluginBinding) :
    NetStreamDrawable {
    override var videoGravity: VideoGravity
        get() = pixelTransform.videoGravity
        set(value) {
            pixelTransform.videoGravity = value
        }

    override var frameRate: Int
        get() = pixelTransform.frameRate
        set(value) {
            pixelTransform.frameRate = value
        }

    override var imageOrientation: ImageOrientation
        get() = pixelTransform.imageOrientation
        set(value) {
            pixelTransform.imageOrientation = value
        }

    override var videoEffect: VideoEffect
        get() = pixelTransform.videoEffect
        set(value) {
            pixelTransform.videoEffect = value
        }

    override var isRotatesWithContent: Boolean
        get() = pixelTransform.isRotatesWithContent
        set(value) {
            pixelTransform.isRotatesWithContent = value
        }

    val id: Long
        get() = entry?.id() ?: 0

    private val pixelTransform: PixelTransform by lazy {
        PixelTransformFactory().create()
    }

    private var stream: NetStream? = null
        set(value) {
            field?.drawable = null
            field = value
            field?.drawable = this
        }

    private var entry: TextureRegistry.SurfaceTextureEntry? = null

    init {
        val entry = binding.textureRegistry.createSurfaceTexture()
        pixelTransform.assetManager = binding.applicationContext.assets
        pixelTransform.imageExtent = Size(1600, 900)
        entry.surfaceTexture().setDefaultBufferSize(1600, 900)
        pixelTransform.outputSurface = Surface(entry.surfaceTexture())
        this.entry = entry
    }

    override fun attachStream(stream: NetStream?) {
        this.stream = stream
    }

    override fun createInputSurface(
        width: Int,
        height: Int,
        format: Int,
        lambda: (surface: Surface) -> Unit
    ) {
        pixelTransform.createInputSurface(width, height, format, lambda)
    }

    override fun dispose() {
        entry?.surfaceTexture()?.release()
        pixelTransform.dispose()
    }

    override fun readPixels(lambda: (bitmap: Bitmap?) -> Unit) {
    }
}