class CaptureSettings {
  int fps;
  bool continuousAutofocus;
  bool continuousExposure;

  CaptureSettings({
    this.continuousAutofocus = false,
    this.continuousExposure = false,
    this.fps = 30,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaptureSettings &&
          runtimeType == other.runtimeType &&
          continuousAutofocus == other.continuousAutofocus &&
          continuousExposure == other.continuousExposure &&
          fps == other.fps);

  @override
  int get hashCode =>
      fps.hashCode ^
      continuousAutofocus.hashCode ^
      continuousExposure.hashCode;

  @override
  String toString() {
    return 'CaptureSettings{' +
        ' fps: $fps,' +
        ' continuousAutofocus: $continuousAutofocus,' +
        ' continuousExposure: $continuousExposure,' +
        '}';
  }

  CaptureSettings copyWith({
    int? fps,
    bool? continuousAutofocus,
    bool? continuousExposure,
  }) {
    return CaptureSettings(
      fps: fps ?? this.fps,
      continuousAutofocus: continuousAutofocus ?? this.continuousAutofocus,
      continuousExposure: continuousExposure ?? this.continuousExposure,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fps': this.fps,
      'continuousAutofocus': this.continuousAutofocus,
      'continuousExposure': this.continuousExposure,
    };
  }

  factory CaptureSettings.fromMap(Map<String, dynamic> map) {
    return CaptureSettings(
      fps: map['fps'] as int,
      continuousAutofocus: map['continuousAutofocus'] as bool,
      continuousExposure: map['continuousExposure'] as bool,
    );
  }
}
