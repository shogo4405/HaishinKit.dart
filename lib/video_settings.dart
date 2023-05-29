enum ProfileLevel {
  H264Baseline31('H264_Baseline_3_1'),
  H264Baseline32('H264_Baseline_3_2'),
  H264Baseline40('H264_Baseline_4_0'),
  H264Baseline41('H264_Baseline_4_1'),
  H264Baseline42('H264_Baseline_4_2'),
  H264Baseline50('H264_Baseline_5_0'),
  H264Baseline51('H264_Baseline_5_1'),
  H264Baseline52('H264_Baseline_5_2'),
  H264High31('H264_High_3_1'),
  H264High32('H264_High_3_2'),
  H264High40('H264_High_4_0'),
  H264High41('H264_High_4_1'),
  H264High42('H264_High_4_2'),
  H264High50('H264_High_5_0'),
  H264High51('H264_High_5_1'),
  H264High52('H264_High_5_2'),
  H264Main31('H264_Main_3_1'),
  H264Main32('H264_Main_3_2'),
  H264Main40('H264_Main_4_0'),
  H264Main41('H264_Main_4_1'),
  H264Main42('H264_Main_4_2'),
  H264Main50('H264_Main_5_0'),
  H264Main51('H264_Main_5_1'),
  H264Main52('H264_Main_5_2'),

  // The following values are supported only on the iOS.
  H264Baseline13('H264_Baseline_1_3'),
  H264Baseline30('H264_Baseline_3_0'),
  H264Extended50('H264_Extended_5_0'),
  H264ExtendedAutoLevel('H264_Extended_AutoLevel'),
  H264High30('H264_High_3_0'),
  H264Main30('H264_Main_3_0'),
  H264BaselineAutoLevel('H264_Baseline_AutoLevel'),
  H264MainAutoLevel('H264_Main_AutoLevel'),
  H264HighAutoLevel('H264_High_AutoLevel'),

  //  The following values are supported only on the iOS 15.0 and above
  H264ConstrainedBaselineAutoLevel('H264_ConstrainedBaseline_AutoLevel'),
  H264ConstrainedHighAutoLevel('H264_ConstrainedHigh_AutoLevel'),
  ;

  const ProfileLevel(this.profileLevelName);
  final String profileLevelName;
}

class VideoSettings {
  bool muted;
  int width;
  int height;
  int bitrate;
  int frameInterval;
  ProfileLevel profileLevel;

//<editor-fold desc="Data Methods">

  VideoSettings({
    this.muted = false,
    this.width = 480,
    this.height = 272,
    this.bitrate = 160 * 1000,
    this.frameInterval = 2,
    this.profileLevel = ProfileLevel.H264Baseline31,
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
          frameInterval == other.frameInterval &&
          profileLevel == other.profileLevel);

  @override
  int get hashCode =>
      muted.hashCode ^
      width.hashCode ^
      height.hashCode ^
      bitrate.hashCode ^
      frameInterval.hashCode ^
      profileLevel.hashCode;

  @override
  String toString() {
    return 'VideoSettings{' +
        ' muted: $muted,' +
        ' width: $width,' +
        ' height: $height,' +
        ' bitrate: $bitrate,' +
        ' frameInterval: $frameInterval,' +
        ' profileLevel: ${profileLevel.profileLevelName},' +
        '}';
  }

  VideoSettings copyWith({
    bool? muted,
    int? width,
    int? height,
    int? bitrate,
    int? frameInterval,
    ProfileLevel? profileLevel,
  }) {
    return VideoSettings(
      muted: muted ?? this.muted,
      width: width ?? this.width,
      height: height ?? this.height,
      bitrate: bitrate ?? this.bitrate,
      frameInterval: frameInterval ?? this.frameInterval,
      profileLevel: profileLevel ?? this.profileLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'muted': this.muted,
      'width': this.width,
      'height': this.height,
      'bitrate': this.bitrate,
      'frameInterval': this.frameInterval,
      'profileLevel': this.profileLevel.profileLevelName,
    };
  }

  factory VideoSettings.fromMap(Map<String, dynamic> map) {
    return VideoSettings(
      muted: map['muted'] as bool,
      width: map['width'] as int,
      height: map['height'] as int,
      bitrate: map['bitrate'] as int,
      frameInterval: map['frameInterval'] as int,
      profileLevel: ProfileLevel.values.byName(map['profileLevel'] as String),
    );
  }

//</editor-fold>
}
