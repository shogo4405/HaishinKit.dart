enum ProfileLevel {
  h264Baseline31('H264_Baseline_3_1'),
  h264Baseline32('H264_Baseline_3_2'),
  h264Baseline40('H264_Baseline_4_0'),
  h264Baseline41('H264_Baseline_4_1'),
  h264Baseline42('H264_Baseline_4_2'),
  h264Baseline50('H264_Baseline_5_0'),
  h264Baseline51('H264_Baseline_5_1'),
  h264Baseline52('H264_Baseline_5_2'),
  h264High31('H264_High_3_1'),
  h264High32('H264_High_3_2'),
  h264High40('H264_High_4_0'),
  h264High41('H264_High_4_1'),
  h264High42('H264_High_4_2'),
  h264High50('H264_High_5_0'),
  h264High51('H264_High_5_1'),
  h264High52('H264_High_5_2'),
  h264Main31('H264_Main_3_1'),
  h264Main32('H264_Main_3_2'),
  h264Main40('H264_Main_4_0'),
  h264Main41('H264_Main_4_1'),
  h264Main42('H264_Main_4_2'),
  h264Main50('H264_Main_5_0'),
  h264Main51('H264_Main_5_1'),
  h264Main52('H264_Main_5_2'),

  // The following values are supported only on the iOS.
  h264Baseline13('H264_Baseline_1_3'),
  h264Baseline30('H264_Baseline_3_0'),
  h264Extended50('H264_Extended_5_0'),
  h264ExtendedAutoLevel('H264_Extended_AutoLevel'),
  h264High30('H264_High_3_0'),
  h264Main30('H264_Main_3_0'),
  h264BaselineAutoLevel('H264_Baseline_AutoLevel'),
  h264MainAutoLevel('H264_Main_AutoLevel'),
  h264HighAutoLevel('H264_High_AutoLevel'),

  //  The following values are supported only on the iOS 15.0 and above
  h264ConstrainedBaselineAutoLevel('H264_ConstrainedBaseline_AutoLevel'),
  h264ConstrainedHighAutoLevel('H264_ConstrainedHigh_AutoLevel'),
  ;

  const ProfileLevel(this.profileLevelName);

  final String profileLevelName;
}

class VideoSettings {
  int width;
  int height;
  int bitrate;
  int frameInterval;
  ProfileLevel profileLevel;

//<editor-fold desc="Data Methods">

  VideoSettings({
    this.width = 480,
    this.height = 272,
    this.bitrate = 160 * 1000,
    this.frameInterval = 2,
    this.profileLevel = ProfileLevel.h264Baseline31,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoSettings &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          bitrate == other.bitrate &&
          frameInterval == other.frameInterval &&
          profileLevel == other.profileLevel);

  @override
  int get hashCode =>
      width.hashCode ^
      height.hashCode ^
      bitrate.hashCode ^
      frameInterval.hashCode ^
      profileLevel.hashCode;

  @override
  String toString() {
    return 'VideoSettings{width: $width, height: $height, bitrate: $bitrate, frameInterval: $frameInterval, profileLevel: ${profileLevel.profileLevelName}}';
  }

  VideoSettings copyWith({
    int? width,
    int? height,
    int? bitrate,
    int? frameInterval,
    ProfileLevel? profileLevel,
  }) {
    return VideoSettings(
      width: width ?? this.width,
      height: height ?? this.height,
      bitrate: bitrate ?? this.bitrate,
      frameInterval: frameInterval ?? this.frameInterval,
      profileLevel: profileLevel ?? this.profileLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'width': width,
      'height': height,
      'bitrate': bitrate,
      'frameInterval': frameInterval,
      'profileLevel': profileLevel.profileLevelName,
    };
  }

  factory VideoSettings.fromMap(Map<String, dynamic> map) {
    return VideoSettings(
      width: map['width'] as int,
      height: map['height'] as int,
      bitrate: map['bitrate'] as int,
      frameInterval: map['frameInterval'] as int,
      profileLevel: ProfileLevel.values.byName(map['profileLevel'] as String),
    );
  }

//</editor-fold>
}
