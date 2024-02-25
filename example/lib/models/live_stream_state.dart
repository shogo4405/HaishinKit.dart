import 'package:haishin_kit/av_capture_session_preset.dart';
import 'package:haishin_kit/video_settings.dart';
import 'package:haishin_kit/video_source.dart';

enum LiveStreamStatus {
  idle(0),

  /// indicate the RTMP connection and stream are initialized
  initialized(1),

  /// indicate the RTMP connection is connected
  connected(2),

  /// indicate the RTMP stream is started to publish
  living(3),

  /// indicate the RTMP stream is stopped
  stopped(4),

  /// indicate the RTMP connection is disconnected
  disconnected(5);

  final int value;

  const LiveStreamStatus(this.value);
}

class LiveStreamState {
  final LiveStreamStatus status;
  final CameraPosition cameraPosition;
  final int audioBitrate;
  final Bitrate videoBitrate;
  final ProfileLevel profileLevel;
  final int frameInterval;
  final Resolution videoResolution;
  final AVCaptureSessionPreset sessionPreset;
  final Fps frameRate;

  const LiveStreamState({
    this.status = LiveStreamStatus.idle,
    this.cameraPosition = CameraPosition.back,
    this.frameRate = Fps.fps30,
    this.sessionPreset = AVCaptureSessionPreset.hd1280x720,
    this.audioBitrate = 64 * 1000,
    this.videoBitrate = Bitrate.medium,
    this.profileLevel = ProfileLevel.h264High31,
    this.frameInterval = 2,
    this.videoResolution = Resolution.hd,
  });

  LiveStreamState copyWith({
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
    return LiveStreamState(
      status: status ?? this.status,
      frameRate: frameRate ?? this.frameRate,
      sessionPreset: sessionPreset ?? this.sessionPreset,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      audioBitrate: audioBitrate ?? this.audioBitrate,
      videoBitrate: videoBitrate ?? this.videoBitrate,
      profileLevel: profileLevel ?? this.profileLevel,
      frameInterval: frameInterval ?? this.frameInterval,
      videoResolution: videoResolution ?? this.videoResolution,
    );
  }

  VideoSettings get nativeVideoSettings => VideoSettings(
        width: videoResolution.width,
        height: videoResolution.height,
        bitrate: videoBitrate.value * 1000,
        frameInterval: frameInterval,
        profileLevel: profileLevel,
      );

  VideoPreviewSetting get previewSetting => VideoPreviewSetting(
        resolution: videoResolution,
        bitrate: videoBitrate,
        fps: frameRate,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiveStreamState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          cameraPosition == other.cameraPosition &&
          audioBitrate == other.audioBitrate &&
          videoBitrate == other.videoBitrate &&
          profileLevel == other.profileLevel &&
          frameInterval == other.frameInterval &&
          videoResolution == other.videoResolution &&
          sessionPreset == other.sessionPreset &&
          frameRate == other.frameRate;

  @override
  int get hashCode =>
      status.hashCode ^
      cameraPosition.hashCode ^
      sessionPreset.hashCode ^
      frameRate.hashCode ^
      audioBitrate.hashCode ^
      videoBitrate.hashCode ^
      profileLevel.hashCode ^
      frameInterval.hashCode ^
      videoResolution.hashCode;

  @override
  String toString() {
    return "LiveStreamState{$status, $cameraPosition, sessionPreset: $sessionPreset, audio/$audioBitrate bps,"
        " video/$videoResolution/$frameRate/$videoBitrate bps, profileLevel: ${profileLevel.profileLevelName}, frameInterval: $frameInterval}";
  }
}

enum Resolution {
  vga(640, 480),
  qhd(960, 540),
  // 720p
  hd(1280, 720),
  // 1080p
  fhd(1920, 1080),
  // 4k
  uhd4k(3840, 2160),
  ;

  final int width;
  final int height;

  const Resolution(this.width, this.height);
}

extension ResolutionAspectRatio on Resolution {
  double get aspectRatio => width / height;
}

enum Bitrate {
  low(64),
  medium(128),
  high(256),
  ultra(512);

  final int value;

  const Bitrate(this.value);
}

enum Fps {
  fps30(30),
  fps60(60);

  final int value;

  const Fps(this.value);
}

class VideoPreviewSetting {
  final int? textureId;
  final Resolution resolution;
  final Bitrate bitrate;
  final Fps fps;

  const VideoPreviewSetting({
    this.resolution = Resolution.hd,
    this.bitrate = Bitrate.medium,
    this.fps = Fps.fps30,
    this.textureId,
  });

  VideoPreviewSetting copyWith({
    Resolution? resolution,
    Bitrate? bitrate,
    Fps? fps,
    int? textureId,
  }) {
    return VideoPreviewSetting(
      resolution: resolution ?? this.resolution,
      bitrate: bitrate ?? this.bitrate,
      fps: fps ?? this.fps,
      textureId: textureId ?? this.textureId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VideoPreviewSetting &&
        other.resolution == resolution &&
        other.bitrate == bitrate &&
        other.fps == fps &&
        other.textureId == textureId;
  }

  @override
  int get hashCode {
    return resolution.hashCode ^
        bitrate.hashCode ^
        fps.hashCode ^
        textureId.hashCode;
  }

  @override
  String toString() {
    return 'VideoPreviewSetting(resolution: $resolution, bitrate: $bitrate, fps: $fps, textureId: $textureId)';
  }
}
