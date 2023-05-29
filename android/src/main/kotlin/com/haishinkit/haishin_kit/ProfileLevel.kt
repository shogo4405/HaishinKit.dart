package com.haishinkit.haishinkit

import android.media.MediaCodecInfo

enum class ProfileLevel(val rawValue: String, val profile: Int, val level: Int) {
    H264Baseline31("H264_Baseline_3_1", MediaCodecInfo.CodecProfileLevel.AVCProfileBaseline, MediaCodecInfo.CodecProfileLevel.AVCLevel31),
    H264Baseline32("H264_Baseline_3_2", MediaCodecInfo.CodecProfileLevel.AVCProfileBaseline, MediaCodecInfo.CodecProfileLevel.AVCLevel32),
    H264Baseline40("H264_Baseline_4_0", MediaCodecInfo.CodecProfileLevel.AVCProfileBaseline, MediaCodecInfo.CodecProfileLevel.AVCLevel4),
    H264Baseline41("H264_Baseline_4_1", MediaCodecInfo.CodecProfileLevel.AVCProfileBaseline, MediaCodecInfo.CodecProfileLevel.AVCLevel41),
    H264Baseline42("H264_Baseline_4_2", MediaCodecInfo.CodecProfileLevel.AVCProfileBaseline, MediaCodecInfo.CodecProfileLevel.AVCLevel42),
    H264Baseline50("H264_Baseline_5_0", MediaCodecInfo.CodecProfileLevel.AVCProfileBaseline, MediaCodecInfo.CodecProfileLevel.AVCLevel5),
    H264Baseline51("H264_Baseline_5_1", MediaCodecInfo.CodecProfileLevel.AVCProfileBaseline, MediaCodecInfo.CodecProfileLevel.AVCLevel51),
    H264Baseline52("H264_Baseline_5_2", MediaCodecInfo.CodecProfileLevel.AVCProfileBaseline, MediaCodecInfo.CodecProfileLevel.AVCLevel52),
    H264Main31("H264_Main_3_1", MediaCodecInfo.CodecProfileLevel.AVCProfileMain, MediaCodecInfo.CodecProfileLevel.AVCLevel31),
    H264Main32("H264_Main_3_2", MediaCodecInfo.CodecProfileLevel.AVCProfileMain, MediaCodecInfo.CodecProfileLevel.AVCLevel32),
    H264Main40("H264_Main_4_0", MediaCodecInfo.CodecProfileLevel.AVCProfileMain, MediaCodecInfo.CodecProfileLevel.AVCLevel4),
    H264Main41("H264_Main_4_1", MediaCodecInfo.CodecProfileLevel.AVCProfileMain, MediaCodecInfo.CodecProfileLevel.AVCLevel41),
    H264Main42("H264_Main_4_2", MediaCodecInfo.CodecProfileLevel.AVCProfileMain, MediaCodecInfo.CodecProfileLevel.AVCLevel42),
    H264Main50("H264_Main_5_0", MediaCodecInfo.CodecProfileLevel.AVCProfileMain, MediaCodecInfo.CodecProfileLevel.AVCLevel5),
    H264Main51("H264_Main_5_1", MediaCodecInfo.CodecProfileLevel.AVCProfileMain, MediaCodecInfo.CodecProfileLevel.AVCLevel51),
    H264Main52("H264_Main_5_2", MediaCodecInfo.CodecProfileLevel.AVCProfileMain, MediaCodecInfo.CodecProfileLevel.AVCLevel52),
    H264High31("H264_High_3_1", MediaCodecInfo.CodecProfileLevel.AVCProfileHigh, MediaCodecInfo.CodecProfileLevel.AVCLevel31),
    H264High32("H264_High_3_2", MediaCodecInfo.CodecProfileLevel.AVCProfileHigh, MediaCodecInfo.CodecProfileLevel.AVCLevel32),
    H264High40("H264_High_4_0", MediaCodecInfo.CodecProfileLevel.AVCProfileHigh, MediaCodecInfo.CodecProfileLevel.AVCLevel4),
    H264High41("H264_High_4_1", MediaCodecInfo.CodecProfileLevel.AVCProfileHigh, MediaCodecInfo.CodecProfileLevel.AVCLevel41),
    H264High42("H264_High_4_2", MediaCodecInfo.CodecProfileLevel.AVCProfileHigh, MediaCodecInfo.CodecProfileLevel.AVCLevel42),
    H264High50("H264_High_5_0", MediaCodecInfo.CodecProfileLevel.AVCProfileHigh, MediaCodecInfo.CodecProfileLevel.AVCLevel5),
    H264High51("H264_High_5_1", MediaCodecInfo.CodecProfileLevel.AVCProfileHigh, MediaCodecInfo.CodecProfileLevel.AVCLevel51),
    H264High52("H264_High_5_2", MediaCodecInfo.CodecProfileLevel.AVCProfileHigh, MediaCodecInfo.CodecProfileLevel.AVCLevel52),
}