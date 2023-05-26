enum AVCaptureSessionPreset {
  high('high'),
  medium('medium'),
  low('low'),
  photo('photo'),
  qHD960x540('qHD960x540'),
  hd1280x720('hd1280x720'),
  hd1920x1080('hd1920x1080'),
  hd4K3840x2160('hd4K3840x2160'),
  qvga320x240('qvga320x240'),
  vga640x480('vga640x480'),
  iFrame960x540('iFrame960x540'),
  iFrame1280x720('iFrame1280x720'),
  cif352x288('cif352x288'),
  ;

  const AVCaptureSessionPreset(this.presetName);
  final String presetName;
}

class CaptureSettings {
  int fps;
  bool continuousAutofocus;
  bool continuousExposure;
  AVCaptureSessionPreset sessionPreset;

  CaptureSettings({
    this.continuousAutofocus = false,
    this.continuousExposure = false,
    this.fps = 30,
    this.sessionPreset = AVCaptureSessionPreset.medium,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaptureSettings &&
          runtimeType == other.runtimeType &&
          continuousAutofocus == other.continuousAutofocus &&
          continuousExposure == other.continuousExposure &&
          fps == other.fps &&
          sessionPreset == other.sessionPreset);

  @override
  int get hashCode =>
      fps.hashCode ^
      continuousAutofocus.hashCode ^
      continuousExposure.hashCode ^
      sessionPreset.hashCode;

  @override
  String toString() {
    return 'CaptureSettings{' +
        ' fps: $fps,' +
        ' continuousAutofocus: $continuousAutofocus,' +
        ' continuousExposure: $continuousExposure,' +
        ' sessionPreset: ${sessionPreset.presetName},' +
        '}';
  }

  CaptureSettings copyWith({
    int? fps,
    bool? continuousAutofocus,
    bool? continuousExposure,
    AVCaptureSessionPreset? sessionPreset,
  }) {
    return CaptureSettings(
      fps: fps ?? this.fps,
      continuousAutofocus: continuousAutofocus ?? this.continuousAutofocus,
      continuousExposure: continuousExposure ?? this.continuousExposure,
      sessionPreset: sessionPreset ?? this.sessionPreset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fps': this.fps,
      'continuousAutofocus': this.continuousAutofocus,
      'continuousExposure': this.continuousExposure,
      'sessionPreset': this.sessionPreset.presetName,
    };
  }

  factory CaptureSettings.fromMap(Map<String, dynamic> map) {
    return CaptureSettings(
      fps: map['fps'] as int,
      continuousAutofocus: map['continuousAutofocus'] as bool,
      continuousExposure: map['continuousExposure'] as bool,
      sessionPreset: AVCaptureSessionPreset.values.byName(map['sessionPreset'] as String),
    );
  }
}
