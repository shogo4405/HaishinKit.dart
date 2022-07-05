class VideoSettings {
  bool muted;
  int width;
  int height;
  int bitrate;
  int frameInterval;

//<editor-fold desc="Data Methods">

  VideoSettings({
    this.muted = false,
    this.width = 480,
    this.height = 272,
    this.bitrate = 160 * 1000,
    this.frameInterval = 2,
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
          frameInterval == other.frameInterval);

  @override
  int get hashCode =>
      muted.hashCode ^
      width.hashCode ^
      height.hashCode ^
      bitrate.hashCode ^
      frameInterval.hashCode;

  @override
  String toString() {
    return 'VideoSettings{' +
        ' muted: $muted,' +
        ' width: $width,' +
        ' height: $height,' +
        ' bitrate: $bitrate,' +
        ' frameInterval: $frameInterval,' +
        '}';
  }

  VideoSettings copyWith({
    bool? muted,
    int? width,
    int? height,
    int? bitrate,
    int? frameInterval,
  }) {
    return VideoSettings(
      muted: muted ?? this.muted,
      width: width ?? this.width,
      height: height ?? this.height,
      bitrate: bitrate ?? this.bitrate,
      frameInterval: frameInterval ?? this.frameInterval,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'muted': this.muted,
      'width': this.width,
      'height': this.height,
      'bitrate': this.bitrate,
      'frameInterval': this.frameInterval,
    };
  }

  factory VideoSettings.fromMap(Map<String, dynamic> map) {
    return VideoSettings(
      muted: map['muted'] as bool,
      width: map['width'] as int,
      height: map['height'] as int,
      bitrate: map['bitrate'] as int,
      frameInterval: map['frameInterval'] as int,
    );
  }

//</editor-fold>
}
