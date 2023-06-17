import Flutter
import Foundation
import HaishinKit
import AVFoundation

class NetStreamDrawableTexture: NSObject, FlutterTexture {
    static let defaultOptions: [String: Any] = [
        kCVPixelBufferCGImageCompatibilityKey as String: true,
        kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
        kCVPixelBufferIOSurfacePropertiesKey as String: NSDictionary()
    ]

    var id: Int64 = 0
    var orientation: AVCaptureVideoOrientation = .portrait
    var position: AVCaptureDevice.Position = .back
    var videoFormatDescription: CMVideoFormatDescription?
    var bounds: CGSize = .zero
    var videoGravity: AVLayerVideoGravity = .resizeAspectFill
    var videoOrientation: AVCaptureVideoOrientation = .portrait
    private var currentSampleBuffer: CMSampleBuffer?
    private let registry: FlutterTextureRegistry
    private let context = CIContext()
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

        let displayImage = CIImage(cvPixelBuffer: imageBuffer)
        var scaleX: CGFloat = 0
        var scaleY: CGFloat = 0
        var translationX: CGFloat = 0
        var translationY: CGFloat = 0
        switch videoGravity {
        case .resize:
            scaleX = bounds.width / displayImage.extent.width
            scaleY = bounds.height / displayImage.extent.height
        case .resizeAspect:
            let scale: CGFloat = min(bounds.width / displayImage.extent.width, bounds.height / displayImage.extent.height)
            scaleX = scale
            scaleY = scale
            translationX = (bounds.width - displayImage.extent.width * scale) / scaleX / 2
            translationY = (bounds.height - displayImage.extent.height * scale) / scaleY / 2
        case .resizeAspectFill:
            let scale: CGFloat = max(bounds.width / displayImage.extent.width, bounds.height / displayImage.extent.height)
            scaleX = scale
            scaleY = scale
            translationX = (bounds.width - displayImage.extent.width * scale) / scaleX / 2
            translationY = (bounds.height - displayImage.extent.height * scale) / scaleY / 2
        default:
            break
        }

        let scaledImage: CIImage = displayImage
            .transformed(by: CGAffineTransform(translationX: translationX, y: translationY))
            .transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, Int(bounds.width), Int(bounds.height), kCVPixelFormatType_32BGRA, Self.defaultOptions as CFDictionary?, &pixelBuffer)

        if let pixelBuffer = pixelBuffer {
            context.render(scaledImage, to: pixelBuffer)
            return Unmanaged<CVPixelBuffer>.passRetained(pixelBuffer)
        }

        return nil
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
