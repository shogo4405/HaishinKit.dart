import Foundation
import Flutter
import HaishinKit
import AVFoundation
import VideoToolbox

final class RTMPStreamHandler: NSObject {
    private let plugin: HaishinKitPlugin
    private var texture: HKStreamFlutterTexture?
    private var instance: RTMPStream?
    private var eventSink: FlutterEventSink?
    private var eventChannel: FlutterEventChannel?
    private var subscription: Task<(), Error>?

    init(plugin: HaishinKitPlugin, handler: RTMPConnectionHandler) {
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
            plugin.mixer?.addOutput(instance)
            self.instance = instance
        }
    }
}

extension RTMPStreamHandler: MethodCallHandler {
    // MARK: MethodCallHandler
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Task {
            guard
                let arguments = call.arguments as? [String: Any?] else {
                result(nil)
                return
            }
            switch call.method {
            case
                "RtmpStream#getHasAudio",
                "RtmpStream#setHasAudio",
                "RtmpStream#getHasVudio",
                "RtmpStream#setHasVudio",
                "RtmpStream#setFrameRate",
                "RtmpStream#setSessionPreset",
                "RtmpStream#attachAudio",
                "RtmpStream#attachVideo",
                "RtmpStream#setScreenSettings":
                plugin.mixer?.handle(call, result: result)
            case "RtmpStream#setAudioSettings":
                guard
                    let settings = arguments["settings"] as? [String: Any?] else {
                    result(nil)
                    return
                }
                if let bitrate = settings["bitrate"] as? NSNumber {
                    var audioSettings = await instance?.audioSettings ?? .default
                    audioSettings.bitRate = bitrate.intValue
                    await instance?.setAudioSettings(audioSettings)
                }
                result(nil)
            case "RtmpStream#setVideoSettings":
                guard
                    let settings = arguments["settings"] as? [String: Any?] else {
                    result(nil)
                    return
                }
                var videoSettings = await instance?.videoSettings ?? .default
                if let bitrate = settings["bitrate"] as? NSNumber {
                    videoSettings.bitRate = bitrate.intValue
                }
                if let width = settings["width"] as? NSNumber, let height = settings["height"] as? NSNumber {
                    videoSettings.videoSize = CGSize(width: .init(width.intValue), height: .init(height.intValue))
                }
                if let frameInterval = settings["frameInterval"] as? NSNumber {
                    videoSettings.maxKeyFrameIntervalDuration = frameInterval.int32Value
                }
                if let profileLevel = settings["profileLevel"] as? String {
                    videoSettings.profileLevel = ProfileLevel(rawValue: profileLevel)?.kVTProfileLevel ?? ProfileLevel.H264_Baseline_AutoLevel.kVTProfileLevel
                }
                await instance?.setVideoSettings(videoSettings)
                result(nil)
            case "RtmpStream#play":
                _ = try? await instance?.play(arguments["name"] as? String)
                result(nil)
            case "RtmpStream#publish":
                _ = try? await instance?.publish(arguments["name"] as? String)
                result(nil)
            case "RtmpStream#registerTexture":
                guard
                    let registry = plugin.registrar?.textures() else {
                    result(nil)
                    return
                }
                if let texture {
                    result(texture.id)
                } else {
                    let texture = HKStreamFlutterTexture(registry: registry)
                    self.texture = texture
                    await instance?.addOutput(texture)
                    result(texture.id)
                }
            case "RtmpStream#unregisterTexture":
                guard
                    let registry = plugin.registrar?.textures() else {
                    result(nil)
                    return
                }
                if let textureId = arguments["id"] as? Int64 {
                    registry.unregisterTexture(textureId)
                }
                result(nil)
            case "RtmpStream#updateTextureSize":
                guard
                    (plugin.registrar?.textures()) != nil else {
                    result(nil)
                    return
                }
                if let texture {
                    if let width = arguments["width"] as? NSNumber,
                       let height = arguments["height"] as? NSNumber {
                        texture.bounds = CGSize(width: width.doubleValue, height: height.doubleValue)
                    }
                    result(texture.id)
                } else {
                    result(nil)
                }
            case "RtmpStream#close":
                _ = try? await instance?.close()
                result(nil)
            case "RtmpStream#dispose":
                if let instance {
                    plugin.mixer?.removeOutput(instance)
                }
                _ = try? await instance?.close()
                instance = nil
                plugin.onDispose(id: Int(bitPattern: ObjectIdentifier(self)))
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}

extension RTMPStreamHandler: FlutterStreamHandler {
    // MARK: FlutterStreamHandler
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
