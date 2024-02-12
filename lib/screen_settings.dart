class ScreenSettings {
  int width;
  int height;

//<editor-fold desc="Data Methods">

  ScreenSettings({
    this.width = 1280,
    this.height = 720,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScreenSettings &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height);

  @override
  int get hashCode => width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'ScreenSettings{width: $width, height: $height}';
  }

  ScreenSettings copyWith({
    int? width,
    int? height,
  }) {
    return ScreenSettings(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'width': width,
      'height': height,
    };
  }

  factory ScreenSettings.fromMap(Map<String, dynamic> map) {
    return ScreenSettings(
      width: map['width'] as int,
      height: map['height'] as int,
    );
  }

//</editor-fold>
}
