class AudioSettings {
  int bitrate;

//<editor-fold desc="Data Methods">

  AudioSettings({
    this.bitrate = 80 * 1000,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioSettings &&
          runtimeType == other.runtimeType &&
          bitrate == other.bitrate);

  @override
  int get hashCode => bitrate.hashCode;

  @override
  String toString() {
    return 'AudioSettings{ bitrate: $bitrate,}';
  }

  AudioSettings copyWith({
    bool? muted,
    int? bitrate,
  }) {
    return AudioSettings(
      bitrate: bitrate ?? this.bitrate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bitrate': bitrate,
    };
  }

  factory AudioSettings.fromMap(Map<String, dynamic> map) {
    return AudioSettings(
      bitrate: map['bitrate'] as int,
    );
  }

//</editor-fold>
}
