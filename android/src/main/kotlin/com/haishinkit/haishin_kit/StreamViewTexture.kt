package com.haishinkit.haishin_kit

import android.util.Size
import android.view.Surface
import com.haishinkit.graphics.PixelTransform
import com.haishinkit.graphics.VideoGravity
import com.haishinkit.graphics.effect.VideoEffect
import com.haishinkit.media.Stream
import com.haishinkit.media.StreamView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.view.TextureRegistry

class StreamViewTexture(binding: FlutterPlugin.FlutterPluginBinding) :
    StreamView {
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

    override var videoEffect: VideoEffect
        get() = pixelTransform.videoEffect
        set(value) {
            pixelTransform.videoEffect = value
        }

    val id: Long
        get() = entry?.id() ?: 0

    var imageExtent: Size
        get() = pixelTransform.imageExtent
        set(value) {
            pixelTransform.imageExtent = value
            entry?.surfaceTexture()?.setDefaultBufferSize(value.width, value.height)
        }

    private val pixelTransform: PixelTransform by lazy {
        PixelTransform.create(binding.applicationContext)
    }

    private var stream: Stream? = null
        set(value) {
            field?.view = null
            field = value
            field?.view = this
            pixelTransform.screen = value?.screen
        }

    private var entry: TextureRegistry.SurfaceTextureEntry? = null

    init {
        val entry = binding.textureRegistry.createSurfaceTexture()
        pixelTransform.surface = Surface(entry.surfaceTexture())
        this.entry = entry
    }

    override fun attachStream(stream: Stream?) {
        this.stream = stream
    }
}