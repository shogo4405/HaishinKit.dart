import 'dart:async';
import 'dart:ui';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:haishin_kit/audio_settings.dart';
import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/av_capture_session_preset.dart';
import 'package:haishin_kit/rtmp_connection.dart';
import 'package:haishin_kit/rtmp_stream.dart';
import 'package:haishin_kit/video_settings.dart';
import 'package:haishin_kit/video_source.dart';

import 'models/live_stream_state.dart';
import 'models/rtmp_event.dart';

class CameraLiveStreamController extends LiveStreamConnectionManager
    with LiveStreamControls, LiveStreamTextureMixin {
  CameraLiveStreamController(super.server, super.streamKey) {
    _initialNotifyState();
  }

  @override
  Future<void> dispose() async {
    print("dispose camera live stream controller");
    await _release();
    super.dispose();
  }

  Future<void> _release() async {
    switch (status) {
      case LiveStreamStatus.living:
      case LiveStreamStatus.connected:
      case LiveStreamStatus.initialized:
        await _releaseStreaming();
        break;
      default:
        break;
    }
  }
}

// todo: (feat) background usage, like pause/resume streaming
class LiveStreamConnectionManager with LiveStreamNotifier {
  final String server;
  final String streamKey;

  LiveStreamConnectionManager(this.server, this.streamKey);

  RtmpConnection? _connection;
  RtmpStream? _stream;

  StreamSubscription? _connectionEventSub;
  StreamSubscription? _streamEventSub;

  bool _initialized = false;

  bool get initialized => _initialized;

  @override
  void dispose() {
    super.dispose();

    /// no need to dispose [RtmpStream] since it will be disposed when [RtmpConnection] is disposed
    /// for android, all [RtmpStream] would be disposed when [RtmpConnection] is disposed
    /// for iOS, [RtmpStream] would deinit when [RtmpConnection] is disposed (deinit)
    ///

    _connection?.dispose();
    _connectionEventSub?.cancel();
    _streamEventSub?.cancel();
  }

  Future<void> _initialize() async {
    if (_initialized) return;

    try {
      await _createConnection();
      await _createStream();

      _initialized = true;
      _notifyStateChange(status: LiveStreamStatus.initialized);
    } catch (e, s) {
      _reportException(e, s);
      _initialized = false;
    }
  }

  Future<void> _createConnection() async {
    _connection ??= await RtmpConnection.create();

    _connectionEventSub?.cancel();
    _connectionEventSub = _connection!.eventChannel
        .receiveBroadcastStream()
        .listen(_onLiveStreamEvent);
  }

  Future<void> _createStream() async {
    if (_connection == null) return;
    _stream ??= await RtmpStream.create(_connection!);

    _stream!.videoSettings = _state.nativeVideoSettings;

    await _attachAudioAndVideo();

    _streamEventSub?.cancel();
    _streamEventSub = _stream!.eventChannel
        .receiveBroadcastStream()
        .listen(_onLiveStreamEvent);
  }

  Future<void> _publishTo(String streamKey) async {
    if (_state.status == LiveStreamStatus.connected ||
        _state.status == LiveStreamStatus.stopped) {
      await _stream?.publish(streamKey);
    }
  }

  ///! for iOS, all status events are notified by [RtmpConnection.eventChannel]
  void _onLiveStreamEvent(dynamic data) async {
    debugPrint("on live stream event: $data");
    final map = <String, dynamic>{};

    for (final entry in (data["data"] as Map).entries) {
      final key = entry.key as String?;
      if (key != null) {
        map[key] = entry.value;
      }
    }

    final event = RtmpEvent.fromMap(map);

    if (event is RtmpConnectionEvent) {
      _onConnectionEvent(event);
    } else if (event is RtmpStreamEvent) {
      _onStreamEvent(event);
    } else {
      _broadcastEvent(event);
    }
  }

  void _onConnectionEvent(RtmpConnectionEvent event) async {
    final status = event.code == RtmpConnectionCode.connectSuccess
        ? LiveStreamStatus.connected
        : LiveStreamStatus.disconnected;
    _notifyStateChange(status: status);
    _broadcastEvent(event);
  }

  void _onStreamEvent(RtmpStreamEvent event) {
    final status = event.code == RtmpStreamCode.publishStart
        ? LiveStreamStatus.living
        : LiveStreamStatus.stopped;

    _notifyStateChange(status: status);
    _broadcastEvent(event);
  }

  /// this value may not be changed synchronously with [_attachAudioAndVideo] and [_detachAudioAndVideo]\
  /// since the two methods are async between dart and native sides.
  bool _resourceAttached = false;

  Future<void> _attachAudioAndVideo() async {
    if (_stream == null || _resourceAttached) return;

    await Future.wait([
      _stream!.attachAudio(AudioSource()),
      _stream!.attachVideo(VideoSource(position: _state.cameraPosition)),
    ]);

    _resourceAttached = true;
  }

  Future<void> _detachAudioAndVideo() async {
    if (_stream == null || !_resourceAttached) return;

    await Future.wait([
      _stream!.attachAudio(null),
      _stream!.attachVideo(null),
    ]);
    print("detach audio and video");
    _resourceAttached = false;
  }
}

mixin LiveStreamNotifier {
  final StreamController<LiveStreamState> _stateController =
      StreamController<LiveStreamState>.broadcast();
  final StreamController<RtmpEvent> _eventController =
      StreamController<RtmpEvent>.broadcast();

  Stream<LiveStreamState> get stateStream => _stateController.stream;

  Stream<RtmpEvent> get eventStream => _eventController.stream;

  LiveStreamState _state = const LiveStreamState();

  LiveStreamState get state => _state;

  LiveStreamStatus get status => _state.status;

  void dispose() {
    _stateController.close();
    _eventController.close();
  }

  void _notifyStateChange({
    LiveStreamStatus? status,
    CameraPosition? cameraPosition,
    Fps? frameRate,
    AVCaptureSessionPreset? sessionPreset,
    int? audioBitrate,
    Bitrate? videoBitrate,
    ProfileLevel? profileLevel,
    int? frameInterval,
    Resolution? videoResolution,
  }) {
    _state = _state.copyWith(
      status: status,
      cameraPosition: cameraPosition,
      frameRate: frameRate,
      sessionPreset: sessionPreset,
      audioBitrate: audioBitrate,
      videoBitrate: videoBitrate,
      profileLevel: profileLevel,
      frameInterval: frameInterval,
      videoResolution: videoResolution,
    );

    debugPrint("state changed: $_state");

    if (!_stateController.isClosed) {
      _stateController.add(_state);
    }
  }

  void _broadcastEvent(RtmpEvent event) {
    debugPrint("RTMP event: $event");

    if (!_eventController.isClosed) {
      _eventController.add(event);
    }
  }

  void _reportException(Object e, [StackTrace? s]) {
    _stateController.addError(e, s);
  }

  void _initialNotifyState() {
    _stateController.onListen = () {
      _stateController.add(_state);
    };
  }
}

mixin LiveStreamControls on LiveStreamConnectionManager {
  Future<void> initialize() async {
    await _initialize();
    _connection?.connect(server);
  }

  Future<void> startStreaming() async {
    if (status == LiveStreamStatus.connected ||
        status == LiveStreamStatus.stopped) {
      await _attachAudioAndVideo();
      await _publishTo(streamKey);
    }
  }

  Future<void> stopStreaming() async {
    if (status == LiveStreamStatus.living) {
      await _releaseStreaming();
    }
  }

  ///! on Android, should [_detachAudioAndVideo] before closing [RtmpStream],
  ///! otherwise, the app will crash
  Future<void> _releaseStreaming() async {
    await _detachAudioAndVideo();
    _notifyStateChange(status: LiveStreamStatus.stopped);
  }

  Future<void> switchCamera() async {
    final position = _state.cameraPosition == CameraPosition.back
        ? CameraPosition.front
        : CameraPosition.back;

    _notifyStateChange(cameraPosition: position);
    _stream?.attachVideo(VideoSource(position: position));
  }

  Future<void> toggleAudio() async {
    final hasAudio = await _stream?.getHasAudio();

    if (hasAudio == null) return;
    _stream?.setHasAudio(!hasAudio);
  }

  Future<void> setVideo({
    Resolution? resolution,
    ProfileLevel? profileLevel,
    Bitrate? bitrate,
  }) async {
    final videoSetting = _state.nativeVideoSettings.copyWith(
      width: resolution?.width,
      height: resolution?.height,
      profileLevel: profileLevel,
      bitrate: bitrate != null ? bitrate.value * 1000 : null,
    );

    if (videoSetting != _state.nativeVideoSettings) {
      _stream?.videoSettings = videoSetting;
      _notifyStateChange(
        videoResolution: resolution,
        profileLevel: profileLevel,
        videoBitrate: bitrate,
      );
    }
  }

  set audioBitrate(int value) {
    if (_state.audioBitrate == value) {
      return;
    }
    _stream?.audioSettings = AudioSettings(bitrate: value);
    _notifyStateChange(audioBitrate: value);
  }

  /// iOS only, android will ignore this
  set sessionPreset(AVCaptureSessionPreset preset) {
    if (_state.sessionPreset == preset) {
      return;
    }
    _stream?.sessionPreset = preset;
    _notifyStateChange(sessionPreset: preset);
  }

  //! after changing frameRate, the rtmp connection will be closed
  // android cannot set frameRate when living
  set frameRate(Fps value) {
    if (_state.frameRate == value || _state.status == LiveStreamStatus.living) {
      return;
    }

    _notifyStateChange(frameRate: value);
    _stream?.frameRate = value.value;
  }
}

mixin LiveStreamTextureMixin on LiveStreamConnectionManager {
  int? _textureId;
  Size? _previousSize;

  int? get textureId => _textureId;

  bool _textureRegistered = false;

  bool get textureRegistered => _textureRegistered;

  Future<int?> registerTexture() async {
    if (!initialized || _textureRegistered) {
      return _textureId;
    }

    try {
      _textureId ??= await _stream!.registerTexture({});
      if (_textureId != null) {
        _textureRegistered = true;
      }
    } catch (e) {
      debugPrint("register texture failed: $e");
      _textureRegistered = false;
    }

    return _textureId;
  }

  Future<void> unregisterTexture() async {
    if (_textureId != null) {
      await _stream?.unregisterTexture({
        "id": _textureId,
      });
      _textureId = null;
    }
  }

  Future<bool> updateTextureSize(Size? size) async {
    if (_textureId == null) return false;

    if (size != null && _previousSize != size) {
      final textureId = await _stream!.updateTextureSize({
        "width": size.width,
        "height": size.height,
      });

      debugPrint(
          "size updated: $size, texture changed: ${textureId != _textureId}");

      assert(textureId == _textureId || textureId == null);

      if (textureId != null) {
        _previousSize = size;
      }
    }

    return _previousSize == size;
  }

  @override
  Future<void> dispose() async {
    await unregisterTexture();
    super.dispose();
  }
}

Future<bool> configureAudioSession() async {
  final session = await AudioSession.instance;
  const config = AudioSessionConfiguration(
    avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
    avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
  );
  try {
    await session.configure(config);
    return true;
  } catch (e) {
    return false;
  }
}
