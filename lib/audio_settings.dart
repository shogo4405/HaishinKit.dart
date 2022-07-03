class AudioSettings {
  bool muted;
  int bitrate;

//<editor-fold desc="Data Methods">

  AudioSettings({
    this.muted = false,
    this.bitrate = 80 * 1000,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioSettings &&
          runtimeType == other.runtimeType &&
          muted == other.muted &&
          bitrate == other.bitrate);

  @override
  int get hashCode => muted.hashCode ^ bitrate.hashCode;

  @override
  String toString() {
    return 'AudioSettings{' + ' muted: $muted,' + ' bitrate: $bitrate,' + '}';
  }

  AudioSettings copyWith({
    bool? muted,
    int? bitrate,
  }) {
    return AudioSettings(
      muted: muted ?? this.muted,
      bitrate: bitrate ?? this.bitrate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'muted': this.muted,
      'bitrate': this.bitrate,
    };
  }

  factory AudioSettings.fromMap(Map<String, dynamic> map) {
    return AudioSettings(
      muted: map['muted'] as bool,
      bitrate: map['bitrate'] as int,
    );
  }

//</editor-fold>
}
