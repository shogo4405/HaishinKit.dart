import Flutter
import Foundation
import HaishinKit
import AVFoundation

class NetStreamDrawableTexture: NSObject, FlutterTexture {
    var id: Int64 = 0
    var orientation: AVCaptureVideoOrientation = .portrait
    var position: AVCaptureDevice.Position = .back
    var videoFormatDescription: CMVideoFormatDescription?
    private var currentSampleBuffer: CMSampleBuffer?
    private let registry: FlutterTextureRegistry
    private var queue = DispatchQueue(label: "com.haishinkit.NetStreamDrawableTexture")
    private var currentStream: NetStream?

    init(registry: FlutterTextureRegistry) {
        self.registry = registry
        super.init()
        id = self.registry.register(self)
    }

    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        guard
            let currentSampleBuffer = currentSampleBuffer,
            let imageBuffer = CMSampleBufferGetImageBuffer(currentSampleBuffer) else {
            return nil
        }
        return Unmanaged<CVPixelBuffer>.passRetained(imageBuffer)
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
