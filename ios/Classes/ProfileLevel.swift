import Foundation
import AVFoundation
import HaishinKit
import VideoToolbox


enum ProfileLevel: String {
    case H264_Baseline_1_3 = "H264_Baseline_1_3"
    case H264_Baseline_3_0 = "H264_Baseline_3_0"
    case H264_Baseline_3_1 = "H264_Baseline_3_1"
    case H264_Baseline_3_2 = "H264_Baseline_3_2"
    case H264_Baseline_4_0 = "H264_Baseline_4_0"
    case H264_Baseline_4_1 = "H264_Baseline_4_1"
    case H264_Baseline_4_2 = "H264_Baseline_4_2"
    case H264_Baseline_5_0 = "H264_Baseline_5_0"
    case H264_Baseline_5_1 = "H264_Baseline_5_1"
    case H264_Baseline_5_2 = "H264_Baseline_5_2"
    case H264_Baseline_AutoLevel = "H264_Baseline_AutoLevel"
    case H264_ConstrainedBaseline_AutoLevel = "H264_ConstrainedBaseline_AutoLevel"
    case H264_ConstrainedHigh_AutoLevel = "H264_ConstrainedHigh_AutoLevel"
    case H264_Extended_5_0 = "H264_Extended_5_0"
    case H264_Extended_AutoLevel = "H264_Extended_AutoLevel"
    case H264_High_3_0 = "H264_High_3_0"
    case H264_High_3_1 = "H264_High_3_1"
    case H264_High_3_2 = "H264_High_3_2"
    case H264_High_4_0 = "H264_High_4_0"
    case H264_High_4_1 = "H264_High_4_1"
    case H264_High_4_2 = "H264_High_4_2"
    case H264_High_5_0 = "H264_High_5_0"
    case H264_High_5_1 = "H264_High_5_1"
    case H264_High_5_2 = "H264_High_5_2"
    case H264_High_AutoLevel = "H264_High_AutoLevel"
    case H264_Main_3_0 = "H264_Main_3_0"
    case H264_Main_3_1 = "H264_Main_3_1"
    case H264_Main_3_2 = "H264_Main_3_2"
    case H264_Main_4_0 = "H264_Main_4_0"
    case H264_Main_4_1 = "H264_Main_4_1"
    case H264_Main_4_2 = "H264_Main_4_2"
    case H264_Main_5_0 = "H264_Main_5_0"
    case H264_Main_5_1 = "H264_Main_5_1"
    case H264_Main_5_2 = "H264_Main_5_2"
    case H264_Main_AutoLevel = "H264_Main_AutoLevel"

    var kVTProfileLevel: CFString {
        switch self {
        case .H264_Baseline_1_3:
            return kVTProfileLevel_H264_Baseline_1_3
        case .H264_Baseline_3_0:
            return kVTProfileLevel_H264_Baseline_3_0
        case .H264_Baseline_3_1:
            return kVTProfileLevel_H264_Baseline_3_1
        case .H264_Baseline_3_2:
            return kVTProfileLevel_H264_Baseline_3_2
        case .H264_Baseline_4_0:
            return kVTProfileLevel_H264_Baseline_4_0
        case .H264_Baseline_4_1:
            return kVTProfileLevel_H264_Baseline_4_1
        case .H264_Baseline_4_2:
            return kVTProfileLevel_H264_Baseline_4_2
        case .H264_Baseline_5_0:
            return kVTProfileLevel_H264_Baseline_5_0
        case .H264_Baseline_5_1:
            return kVTProfileLevel_H264_Baseline_5_1
        case .H264_Baseline_5_2:
            return kVTProfileLevel_H264_Baseline_5_2
        case .H264_Baseline_AutoLevel:
            return kVTProfileLevel_H264_Baseline_AutoLevel
        case .H264_ConstrainedBaseline_AutoLevel:
            if #available(iOS 15.0, *) {
                return kVTProfileLevel_H264_ConstrainedBaseline_AutoLevel
            } else {
                return kVTProfileLevel_H264_Baseline_AutoLevel
            }
        case .H264_ConstrainedHigh_AutoLevel:
            if #available(iOS 15.0, *) {
                return kVTProfileLevel_H264_ConstrainedHigh_AutoLevel
            } else {
                return kVTProfileLevel_H264_High_AutoLevel
            }
        case .H264_Extended_5_0:
            return kVTProfileLevel_H264_Extended_5_0
        case .H264_Extended_AutoLevel:
            return kVTProfileLevel_H264_Extended_AutoLevel
        case .H264_High_3_0:
            return kVTProfileLevel_H264_High_3_0
        case .H264_High_3_1:
            return kVTProfileLevel_H264_High_3_1
        case .H264_High_3_2:
            return kVTProfileLevel_H264_High_3_2
        case .H264_High_4_0:
            return kVTProfileLevel_H264_High_4_0
        case .H264_High_4_1:
            return kVTProfileLevel_H264_High_4_1
        case .H264_High_4_2:
            return kVTProfileLevel_H264_High_4_2
        case .H264_High_5_0:
            return kVTProfileLevel_H264_High_5_0
        case .H264_High_5_1:
            return kVTProfileLevel_H264_High_5_1
        case .H264_High_5_2:
            return kVTProfileLevel_H264_High_5_2
        case .H264_High_AutoLevel:
            return kVTProfileLevel_H264_High_AutoLevel
        case .H264_Main_3_0:
            return kVTProfileLevel_H264_Main_3_0
        case .H264_Main_3_1:
            return kVTProfileLevel_H264_Main_3_1
        case .H264_Main_3_2:
            return kVTProfileLevel_H264_Main_3_2
        case .H264_Main_4_0:
            return kVTProfileLevel_H264_Main_4_0
        case .H264_Main_4_1:
            return kVTProfileLevel_H264_Main_4_1
        case .H264_Main_4_2:
            return kVTProfileLevel_H264_Main_4_2
        case .H264_Main_5_0:
            return kVTProfileLevel_H264_Main_5_0
        case .H264_Main_5_1:
            return kVTProfileLevel_H264_Main_5_1
        case .H264_Main_5_2:
            return kVTProfileLevel_H264_Main_5_2
        case .H264_Main_AutoLevel:
            return kVTProfileLevel_H264_Main_AutoLevel
        }
    }
}
