import Foundation
import Flutter
import HaishinKit
import AVFoundation

class RTMPStreamHandler {
    var instances: [Int: RTMPStream] = [:]
    private let plugin: SwiftHaishinKitPlugin

    init(plugin: SwiftHaishinKitPlugin) {
        self.plugin = plugin
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "RtmpStream#create":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber,
                let connection = plugin.rtmpConnectionHandler.instances[memory.intValue] else {
                return
            }
            let count = instances.count
            instances[count] = RTMPStream(connection: connection)
            result(NSNumber(value: count))
        case "RtmpStream#setAudioSettings":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber,
                let stream = instances[memory.intValue],
                let settings = arguments["settings"] as? [String: Any?] else {
                return
            }
            if let muted = settings["muted"] as? Bool {
                stream.audioSettings[.muted] = muted
            }
            if let bitrate = settings["bitrate"] as? NSNumber {
                stream.audioSettings[.bitrate] = bitrate.intValue
            }
            result(nil)
        case "RtmpStream#setVideoSettings":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber,
                let stream = instances[memory.intValue],
                let settings = arguments["settings"] as? [String: Any?] else {
                return
            }
            if let muted = settings["muted"] as? Bool {
                stream.videoSettings[.muted] = muted
            }
            if let bitrate = settings["bitrate"] as? NSNumber {
                stream.videoSettings[.bitrate] = bitrate.intValue
            }
            if let width = settings["width"] as? NSNumber {
                stream.videoSettings[.width] = width.intValue
            }
            if let height = settings["height"] as? NSNumber {
                stream.videoSettings[.height] = height.intValue
            }
            if let frameInterval = settings["frameInterval"] as? NSNumber {
                stream.videoSettings[.maxKeyFrameIntervalDuration] = frameInterval.intValue
            }
            result(nil)
        case "RtmpStream#attachAudio":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber else {
                return
            }
            let source = arguments["source"] as? [String: Any?]
            if source == nil {
                instances[memory.intValue]?.attachAudio(nil)
            } else {
                instances[memory.intValue]?.attachAudio(AVCaptureDevice.default(for: .audio))
            }
            result(nil)
        case "RtmpStream#attachVideo":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber else {
                return
            }
            let source = arguments["source"] as? [String: Any?]
            if source == nil {
                instances[memory.intValue]?.attachCamera(nil)
            } else {
                instances[memory.intValue]?.attachCamera(DeviceUtil.device(withPosition: .back))
            }
            result(nil)
        case "RtmpStream#play":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber else {
                return
            }
            instances[memory.intValue]?.play(arguments["name"] as? String)
        case "RtmpStream#publish":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber else {
                return
            }
            instances[memory.intValue]?.publish(arguments["name"] as? String)
            result(nil)
        case "RtmpStream#registerTexture":
            guard
                let arguments = call.arguments as? [String: Any?],
                let memory = arguments["memory"] as? NSNumber,
                let stream = instances[memory.intValue],
                let registry = plugin.registrar?.textures() else {
                return
            }
            if (stream.mixer.drawable == nil) {
                let texture = NetStreamDrawableTexture(registry: registry)
                texture.attachStream(stream)
                result(texture.id)
            } else {
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
