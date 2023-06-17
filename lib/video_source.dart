enum CameraPosition { front, back }

class VideoSource {
  CameraPosition position;

//<editor-fold desc="Data Methods">

  VideoSource({
    required this.position,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoSource &&
          runtimeType == other.runtimeType &&
          position == other.position);

  @override
  int get hashCode => position.hashCode;

  @override
  String toString() {
    return 'VideoSource{position: $position}';
  }

  VideoSource copyWith({
    CameraPosition? position,
  }) {
    return VideoSource(
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'position': this.position.name,
    };
  }

  factory VideoSource.fromMap(Map<String, dynamic> map) {
    return VideoSource(
      position: map['position'] as CameraPosition,
    );
  }

//</editor-fold>
}
