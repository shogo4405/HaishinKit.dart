import Foundation
import Flutter
import HaishinKit
import AVFoundation
import VideoToolbox

final class MediaMixerHandler: NSObject {
    private lazy var instance = MediaMixer(multiCamSessionEnabled: false, multiTrackAudioMixingEnabled: false)

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    func addOutput(_ output: some MediaMixerOutput) {
        Task { await instance.addOutput(output) }
    }

    func removeOutput(_ output: some MediaMixerOutput) {
        Task { await instance.removeOutput(output) }
    }

    func stopRunning() {
        Task {
            await instance.stopCapturing()
            await instance.stopRunning()
        }
    }

    @objc
    private func on(_ notification: Notification) {
        guard let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) else {
            return
        }
        Task { await instance.setVideoOrientation(orientation) }
    }
}

extension MediaMixerHandler: MethodCallHandler {
    // MARK: MethodCallHandler
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Task {
            guard
                let arguments = call.arguments as? [String: Any?] else {
                result(nil)
                return
            }
            switch call.method {
            case "RtmpStream#getHasAudio":
                result(await !instance.audioMixerSettings.isMuted)
            case "RtmpStream#setHasAudio":
                guard let hasAudio = arguments["value"] as? Bool else {
                    result(nil)
                    return
                }
                var audioMixerSettings = await instance.audioMixerSettings
                audioMixerSettings.isMuted = !hasAudio
                await instance.setAudioMixerSettings(audioMixerSettings)
                result(nil)
            case "RtmpStream#getHasVudio":
                result(await !instance.videoMixerSettings.isMuted)
            case "RtmpStream#setHasVudio":
                guard let hasVideo = arguments["value"] as? Bool else {
                    result(nil)
                    return
                }
                var videoMixerSettings = await instance.videoMixerSettings
                videoMixerSettings.isMuted = !hasVideo
                await instance.setVideoMixerSettings(videoMixerSettings)
                result(nil)
            case "RtmpStream#setFrameRate":
                guard
                    let frameRate = arguments["value"] as? NSNumber else {
                    result(nil)
                    return
                }
                await instance.setFrameRate(frameRate.doubleValue)
                result(nil)
            case "RtmpStream#setSessionPreset":
                guard let sessionPreset = arguments["value"] as? String else {
                    result(nil)
                    return
                }
                switch sessionPreset {
                case "high":
                    await instance.setSessionPreset(.high)
                case "medium":
                    await instance.setSessionPreset(.medium)
                case "low":
                    await instance.setSessionPreset(.low)
                case "hd1280x720":
                    await instance.setSessionPreset(.hd1280x720)
                case "hd1920x1080":
                    await instance.setSessionPreset(.hd1920x1080)
                case "hd4K3840x2160":
                    await instance.setSessionPreset(.hd4K3840x2160)
                case "vga640x480":
                    await instance.setSessionPreset(.vga640x480)
                case "iFrame960x540":
                    await instance.setSessionPreset(.iFrame960x540)
                case "iFrame1280x720":
                    await instance.setSessionPreset(.iFrame1280x720)
                case "cif352x288":
                    await instance.setSessionPreset(.cif352x288)
                default:
                    await instance.setSessionPreset(AVCaptureSession.Preset.hd1280x720)
                }
                result(nil)
            case "RtmpStream#attachAudio":
                let source = arguments["source"] as? [String: Any?]
                if source == nil {
                    try? await instance.attachAudio(nil)
                } else {
                    try? await instance.attachAudio(AVCaptureDevice.default(for: .audio))
                }
                result(nil)
            case "RtmpStream#setScreenSettings":
                guard
                    let settings = arguments["settings"] as? [String: Any?],
                    let width = settings["width"] as? NSNumber,
                    let height = settings["height"] as? NSNumber else {
                    result(nil)
                    return
                }
                Task { @ScreenActor in
                    instance.screen.size = CGSize(width: CGFloat(width.floatValue), height: CGFloat(height.floatValue))
                    result(nil)
                }
            case "RtmpStream#attachVideo":
                let source = arguments["source"] as? [String: Any?]
                if source == nil {
                    try? await instance.attachVideo(nil, track: 0)
                } else {
                    var devicePosition = AVCaptureDevice.Position.back
                    if let position = source?["position"] as? String {
                        switch position {
                        case "front":
                            devicePosition = .front
                        case "back":
                            devicePosition = .back
                        default:
                            break
                        }
                    }
                    if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: devicePosition) {
                        try? await instance.attachVideo(device, track: 0)
                    }
                }
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
