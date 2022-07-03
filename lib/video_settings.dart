class VideoSettings {
  bool muted;
  int width;
  int height;
  int bitrate;
  int maxKeyFrameIntervalDuration;

//<editor-fold desc="Data Methods">

  VideoSettings({
    this.muted = false,
    this.width = 480,
    this.height = 272,
    this.bitrate = 160 * 1000,
    this.maxKeyFrameIntervalDuration = 2,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoSettings &&
          runtimeType == other.runtimeType &&
          muted == other.muted &&
          width == other.width &&
          height == other.height &&
          bitrate == other.bitrate &&
          maxKeyFrameIntervalDuration == other.maxKeyFrameIntervalDuration);

  @override
  int get hashCode =>
      muted.hashCode ^
      width.hashCode ^
      height.hashCode ^
      bitrate.hashCode ^
      maxKeyFrameIntervalDuration.hashCode;

  @override
  String toString() {
    return 'VideoSettings{' +
        ' muted: $muted,' +
        ' width: $width,' +
        ' height: $height,' +
        ' bitrate: $bitrate,' +
        ' maxKeyFrameIntervalDuration: $maxKeyFrameIntervalDuration,' +
        '}';
  }

  VideoSettings copyWith({
    bool? muted,
    int? width,
    int? height,
    int? bitrate,
    int? maxKeyFrameIntervalDuration,
  }) {
    return VideoSettings(
      muted: muted ?? this.muted,
      width: width ?? this.width,
      height: height ?? this.height,
      bitrate: bitrate ?? this.bitrate,
      maxKeyFrameIntervalDuration:
          maxKeyFrameIntervalDuration ?? this.maxKeyFrameIntervalDuration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'muted': this.muted,
      'width': this.width,
      'height': this.height,
      'bitrate': this.bitrate,
      'maxKeyFrameIntervalDuration': this.maxKeyFrameIntervalDuration,
    };
  }

  factory VideoSettings.fromMap(Map<String, dynamic> map) {
    return VideoSettings(
      muted: map['muted'] as bool,
      width: map['width'] as int,
      height: map['height'] as int,
      bitrate: map['bitrate'] as int,
      maxKeyFrameIntervalDuration: map['maxKeyFrameIntervalDuration'] as int,
    );
  }

//</editor-fold>
}
