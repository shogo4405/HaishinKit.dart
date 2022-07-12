import Flutter
import Foundation
import HaishinKit
import AVFoundation

class NetStreamDrawableTexture: NSObject, FlutterTexture {
    var orientation: AVCaptureVideoOrientation = .portrait
    var position: AVCaptureDevice.Position = .back
    var currentSampleBuffer: CMSampleBuffer?
    var videoFormatDescription: CMVideoFormatDescription?
    var id: Int64 = 0
    private let registry: FlutterTextureRegistry
    private var queue = DispatchQueue(label: "com.haishinkit.NetStreamDrawableTexture")
    private var currentStream: NetStream?

    init(registry: FlutterTextureRegistry) {
        self.registry = registry
        super.init()
        id = self.registry.register(self)
    }

    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        var pixelBuffer: Unmanaged<CVPixelBuffer>?
        if #available(iOS 13.0, *) {
            if let imageBuffer = currentSampleBuffer?.imageBuffer {
                queue.sync {
                    pixelBuffer = Unmanaged<CVPixelBuffer>.passRetained(imageBuffer)
                }
            }
        } else {
        }
        return pixelBuffer
    }
}

extension NetStreamDrawableTexture: NetStreamDrawable {
    // MARK: - NetStreamDrawable
    func attachStream(_ stream: NetStream?) {
        guard let stream = stream else {
            self.currentStream = nil
            return
        }
        stream.lockQueue.async {
            stream.mixer.drawable = self
            self.currentStream = stream
            stream.mixer.startRunning()
        }
    }

    func enqueue(_ sampleBuffer: CMSampleBuffer?) {
        currentSampleBuffer = sampleBuffer
        self.registry.textureFrameAvailable(id)
    }
}
