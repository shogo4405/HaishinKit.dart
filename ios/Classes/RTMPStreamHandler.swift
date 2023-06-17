import Foundation
import Flutter
import HaishinKit
import AVFoundation
import VideoToolbox

class RTMPStreamHandler: NSObject, MethodCallHandler {
    private let plugin: SwiftHaishinKitPlugin
    private var instance: RTMPStream?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?

    init(plugin: SwiftHaishinKitPlugin, handler: RTMPConnectionHandler) {
        self.plugin = plugin
        super.init()
        let id = Int(bitPattern: ObjectIdentifier(self))
        if let registrar = plugin.registrar {
            self.eventChannel = FlutterEventChannel(name: "com.haishinkit.eventchannel/\(id)", binaryMessenger: registrar.messenger())
            self.eventChannel?.setStreamHandler(self)
        } else {
            self.eventChannel = nil
        }
        if let connection = handler.instance {
            let instance = RTMPStream(connection: connection)
            instance.addEventListener(.rtmpStatus, selector: #selector(RTMPStreamHandler.handler), observer: self)
            if let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) {
                instance.videoOrientation = orientation
            }
            NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
            self.instance = instance
        }
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let arguments = call.arguments as? [String: Any?] else {
            result(nil)
            return
        }
        switch call.method {
        case "RtmpStream#getHasAudio":
            result(instance?.hasAudio)
        case "RtmpStream#setHasAudio":
            guard let hasAudio = arguments["value"] as? Bool else {
                result(nil)
                return
            }
            instance?.hasAudio = hasAudio
            result(nil)
        case "RtmpStream#getHasVudio":
            result(instance?.hasVideo)
        case "RtmpStream#setHasVudio":
            guard let hasVideo = arguments["value"] as? Bool else {
                result(nil)
                return
            }
            instance?.hasVideo = hasVideo
            result(nil)
        case "RtmpStream#setFrameRate":
            guard
                let frameRate = arguments["value"] as? NSNumber else {
                result(nil)
                return
            }
            instance?.frameRate = frameRate.doubleValue
            result(nil)
        case "RtmpStream#setSessionPreset":
            guard let sessionPreset = arguments["value"] as? String else {
                result(nil)
                return
            }
            switch sessionPreset {
            case "high":
                instance?.sessionPreset = .high
            case "medium":
                instance?.sessionPreset = .medium
            case "low":
                instance?.sessionPreset = .low
            case "hd1280x720":
                instance?.sessionPreset = .hd1280x720
            case "hd1920x1080":
                instance?.sessionPreset = .hd1920x1080
            case "hd4K3840x2160":
                instance?.sessionPreset = .hd4K3840x2160
            case "vga640x480":
                instance?.sessionPreset = .vga640x480
            case "iFrame960x540":
                instance?.sessionPreset = .iFrame960x540
            case "iFrame1280x720":
                instance?.sessionPreset = .iFrame1280x720
            case "cif352x288":
                instance?.sessionPreset = .cif352x288
            default:
                instance?.sessionPreset = AVCaptureSession.Preset.hd1280x720
            }
            result(nil)
        case "RtmpStream#setAudioSettings":
            guard
                let settings = arguments["settings"] as? [String: Any?] else {
                result(nil)
                return
            }
            if let bitrate = settings["bitrate"] as? NSNumber {
                instance?.audioSettings.bitRate = bitrate.intValue
            }
            result(nil)
        case "RtmpStream#setVideoSettings":
            guard
                let settings = arguments["settings"] as? [String: Any?] else {
                result(nil)
                return
            }
            if let bitrate = settings["bitrate"] as? NSNumber {
                instance?.videoSettings.bitRate = bitrate.uint32Value
            }
            if let width = settings["width"] as? NSNumber, let height = settings["height"] as? NSNumber {
                instance?.videoSettings.videoSize = .init(width: width.int32Value, height: height.int32Value)
            }
            if let frameInterval = settings["frameInterval"] as? NSNumber {
                instance?.videoSettings.maxKeyFrameIntervalDuration = frameInterval.int32Value
            }
            if let profileLevel = settings["profileLevel"] as? String {
                instance?.videoSettings.profileLevel = ProfileLevel(rawValue: profileLevel)?.kVTProfileLevel ?? ProfileLevel.H264_Baseline_AutoLevel.kVTProfileLevel
            }
            result(nil)
        case "RtmpStream#attachAudio":
            let source = arguments["source"] as? [String: Any?]
            if source == nil {
                instance?.attachAudio(nil)
            } else {
                instance?.attachAudio(AVCaptureDevice.default(for: .audio))
            }
            result(nil)
        case "RtmpStream#attachVideo":
            let source = arguments["source"] as? [String: Any?]
            if source == nil {
                instance?.attachCamera(nil)
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
                    instance?.attachCamera(device)
                }
            }
            result(nil)
        case "RtmpStream#play":
            instance?.play(arguments["name"] as? String)
            result(nil)
        case "RtmpStream#publish":
            instance?.publish(arguments["name"] as? String)
            result(nil)
        case "RtmpStream#registerTexture":
            guard
                let registry = plugin.registrar?.textures() else {
                result(nil)
                return
            }
            if instance?.mixer.drawable == nil {
                let texture = NetStreamDrawableTexture(registry: registry)
                if let instance = instance {
                    texture.attachStream(instance)
                }
                result(texture.id)
            } else {
                if let texture = instance?.mixer.drawable as? NetStreamDrawableTexture {
                    if let width = arguments["width"] as? NSNumber,
                       let height = arguments["height"] as? NSNumber {
                        texture.bounds = CGSize(width: width.doubleValue, height: height.doubleValue)
                    }
                }
                result(nil)
            }
        case "RtmpStream#close":
            instance?.close()
            result(nil)
        case "RtmpStream#dispose":
            instance?.removeEventListener(.rtmpStatus, selector: #selector(handler))
            instance?.close()
            instance = nil
            plugin.onDispose(id: Int(bitPattern: ObjectIdentifier(self)))
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @objc
    private func handler(_ notification: Notification) {
        let event = Event.from(notification)
        var map: [String: Any?] = [:]
        map["type"] = event.type.rawValue
        map["data"] = ASObjectUtil.removeEmpty(event.data)
        eventSink?(map)
    }

    @objc
    private func on(_ notification: Notification) {
        guard let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) else {
            return
        }
        instance?.videoOrientation = orientation
    }
}

extension RTMPStreamHandler: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
