enum ProfileLevel {
  kVTProfileLevel_HEVC_Main_AutoLevel('kVTProfileLevel_HEVC_Main_AutoLevel'),
  kVTProfileLevel_HEVC_Main10_AutoLevel('kVTProfileLevel_HEVC_Main10_AutoLevel'),
  kVTProfileLevel_HEVC_Main42210_AutoLevel('kVTProfileLevel_HEVC_Main42210_AutoLevel'),
  kVTProfileLevel_H264_Baseline_1_3('kVTProfileLevel_H264_Baseline_1_3'),
  kVTProfileLevel_H264_Baseline_3_0('kVTProfileLevel_H264_Baseline_3_0'),
  kVTProfileLevel_H264_Baseline_3_1('kVTProfileLevel_H264_Baseline_3_1'),
  kVTProfileLevel_H264_Baseline_3_2('kVTProfileLevel_H264_Baseline_3_2'),
  kVTProfileLevel_H264_Baseline_4_0('kVTProfileLevel_H264_Baseline_4_0'),
  kVTProfileLevel_H264_Baseline_4_1('kVTProfileLevel_H264_Baseline_4_1'),
  kVTProfileLevel_H264_Baseline_4_2('kVTProfileLevel_H264_Baseline_4_2'),
  kVTProfileLevel_H264_Baseline_5_0('kVTProfileLevel_H264_Baseline_5_0'),
  kVTProfileLevel_H264_Baseline_5_1('kVTProfileLevel_H264_Baseline_5_1'),
  kVTProfileLevel_H264_Baseline_5_2('kVTProfileLevel_H264_Baseline_5_2'),
  kVTProfileLevel_H264_Baseline_AutoLevel('kVTProfileLevel_H264_Baseline_AutoLevel'),
  kVTProfileLevel_H264_ConstrainedBaseline_AutoLevel('kVTProfileLevel_H264_ConstrainedBaseline_AutoLevel'),
  kVTProfileLevel_H264_ConstrainedHigh_AutoLevel('kVTProfileLevel_H264_ConstrainedHigh_AutoLevel'),
  kVTProfileLevel_H264_Extended_5_0('kVTProfileLevel_H264_Extended_5_0'),
  kVTProfileLevel_H264_Extended_AutoLevel('kVTProfileLevel_H264_Extended_AutoLevel'),
  kVTProfileLevel_H264_High_3_0('kVTProfileLevel_H264_High_3_0'),
  kVTProfileLevel_H264_High_3_1('kVTProfileLevel_H264_High_3_1'),
  kVTProfileLevel_H264_High_3_2('kVTProfileLevel_H264_High_3_2'),
  kVTProfileLevel_H264_High_4_0('kVTProfileLevel_H264_High_4_0'),
  kVTProfileLevel_H264_High_4_1('kVTProfileLevel_H264_High_4_1'),
  kVTProfileLevel_H264_High_4_2('kVTProfileLevel_H264_High_4_2'),
  kVTProfileLevel_H264_High_5_0('kVTProfileLevel_H264_High_5_0'),
  kVTProfileLevel_H264_High_5_1('kVTProfileLevel_H264_High_5_1'),
  kVTProfileLevel_H264_High_5_2('kVTProfileLevel_H264_High_5_2'),
  kVTProfileLevel_H264_High_AutoLevel('kVTProfileLevel_H264_High_AutoLevel'),
  kVTProfileLevel_H264_Main_3_0('kVTProfileLevel_H264_Main_3_0'),
  kVTProfileLevel_H264_Main_3_1('kVTProfileLevel_H264_Main_3_1'),
  kVTProfileLevel_H264_Main_3_2('kVTProfileLevel_H264_Main_3_2'),
  kVTProfileLevel_H264_Main_4_0('kVTProfileLevel_H264_Main_4_0'),
  kVTProfileLevel_H264_Main_4_1('kVTProfileLevel_H264_Main_4_1'),
  kVTProfileLevel_H264_Main_4_2('kVTProfileLevel_H264_Main_4_2'),
  kVTProfileLevel_H264_Main_5_0('kVTProfileLevel_H264_Main_5_0'),
  kVTProfileLevel_H264_Main_5_1('kVTProfileLevel_H264_Main_5_1'),
  kVTProfileLevel_H264_Main_5_2('kVTProfileLevel_H264_Main_5_2'),
  kVTProfileLevel_H264_Main_AutoLevel('kVTProfileLevel_H264_Main_AutoLevel'),
  kVTProfileLevel_MP4V_Simple_L0('kVTProfileLevel_MP4V_Simple_L0'),
  kVTProfileLevel_MP4V_Simple_L1('kVTProfileLevel_MP4V_Simple_L1'),
  kVTProfileLevel_MP4V_Simple_L2('kVTProfileLevel_MP4V_Simple_L2'),
  kVTProfileLevel_MP4V_Simple_L3('kVTProfileLevel_MP4V_Simple_L3'),
  kVTProfileLevel_MP4V_AdvancedSimple_L0('kVTProfileLevel_MP4V_AdvancedSimple_L0'),
  kVTProfileLevel_MP4V_AdvancedSimple_L1('kVTProfileLevel_MP4V_AdvancedSimple_L1'),
  kVTProfileLevel_MP4V_AdvancedSimple_L2('kVTProfileLevel_MP4V_AdvancedSimple_L2'),
  kVTProfileLevel_MP4V_AdvancedSimple_L3('kVTProfileLevel_MP4V_AdvancedSimple_L3'),
  kVTProfileLevel_MP4V_AdvancedSimple_L4('kVTProfileLevel_MP4V_AdvancedSimple_L4'),
  kVTProfileLevel_MP4V_Main_L2('kVTProfileLevel_MP4V_Main_L2'),
  kVTProfileLevel_MP4V_Main_L3('kVTProfileLevel_MP4V_Main_L3'),
  kVTProfileLevel_MP4V_Main_L4('kVTProfileLevel_MP4V_Main_L4'),
  kVTProfileLevel_H263_Profile0_Level10('kVTProfileLevel_H263_Profile0_Level10'),
  kVTProfileLevel_H263_Profile0_Level45('kVTProfileLevel_H263_Profile0_Level45'),
  kVTProfileLevel_H263_Profile3_Level45('kVTProfileLevel_H263_Profile3_Level45'),
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
    this.profileLevel = ProfileLevel.kVTProfileLevel_H264_Baseline_AutoLevel,
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
