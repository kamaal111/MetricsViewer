//
//  DataItemResponse.swift
//  
//
//  Created by Kamaal Farah on 09/07/2021.
//

import Foundation

/// Decoded response from data endpoint
public struct DataItemResponse: Codable, Identifiable {
    public let id: Int
    public let appVersion: String
    public let appBuildVersion: String
    public let appID: Int
    public let payload: Payload
}

extension DataItemResponse {
    enum CodingKeys: String, CodingKey {
        case id
        case appVersion = "app_version"
        case appBuildVersion = "app_build_version"
        case appID = "app_id"
        case payload
    }

    public struct Payload: Codable {
        public let locationActivityMetrics: LocationActivityMetrics?
        public let cellularConditionMetrics: CellularConditionMetrics?
        public let metaData: MetaData?
        public let gpuMetrics: GpuMetrics?
        public let memoryMetrics: MemoryMetrics?
        public let signpostMetrics: [SignpostMetrics]?
        public let displayMetrics: DisplayMetrics?
        public let cpuMetrics: CpuMetrics?
        public let networkTransferMetrics: NetworkTransferMetrics?
        public let diskIOMetrics: DiskIOMetrics?
        /// An object representing metrics about app launch time.
        public let applicationLaunchMetrics: ApplicationLaunchMetrics?
        public let applicationTimeMetrics: ApplicationTimeMetrics?
        public let applicationResponsivenessMetrics: ApplicationResponsivenessMetrics?
        public let appVersion: String

        @DateValueCodable<MetricsDateCodableStrategy>
        public var timeStampBegin: Date
        @DateValueCodable<MetricsDateCodableStrategy>
        public var timeStampEnd: Date
    }
}

extension DataItemResponse.Payload {
    public struct LocationActivityMetrics: Codable {
        public let cumulativeBestAccuracyForNavigationTime: String
        public let cumulativeBestAccuracyTime: String
        public let cumulativeHundredMetersAccuracyTime: String
        public let cumulativeNearestTenMetersAccuracyTime: String
        public let cumulativeKilometerAccuracyTime: String
        public let cumulativeThreeKilometersAccuracyTime: String
    }

    public struct CellularConditionMetrics: Codable {
        public let cellConditionTime: Histogram
    }

    public struct MetaData: Codable {
        public let appBuildVersion: String
        public let osVersion: String
        public let regionFormat: String
        public let deviceType: String
    }

    /// An object representing metrics about the use of the GPU.
    public struct GpuMetrics: Codable {
        /// The total amount of GPU time used by the app.
        public let cumulativeGPUTime: String
    }

    public struct MemoryMetrics: Codable {
        public let peakMemoryUsage: String
        public let averageSuspendedMemory: AverageSuspendedMemory
    }

    public struct SignpostMetrics: Codable {
        public let signpostIntervalData: SignpostIntervalData
        public let signpostCategory: String
        public let signpostName: String
        public let totalSignpostCount: Int
    }

    public struct DisplayMetrics: Codable {
        public let averagePixelLuminance: AveragePixelLuminance
    }

    public struct CpuMetrics: Codable {
        public let cumulativeCPUTime: String
    }

    public struct NetworkTransferMetrics: Codable {
        public let cumulativeCellularDownload: String
        public let cumulativeWifiDownload: String
        public let cumulativeCellularUpload: String
        public let cumulativeWifiUpload: String
    }

    public struct DiskIOMetrics: Codable {
        public let cumulativeLogicalWrites: String
    }

    /// An object representing metrics about app launch time.
    public struct ApplicationLaunchMetrics: Codable {
        /// A histogram of the different amounts of time taken to launch the app.
        public let histogrammedTimeToFirstDrawKey: Histogram?
        /// A histogram of the different amounts of time taken to resume the app from the background.
        public let histogrammedResumeTime: Histogram?
    }

    public struct ApplicationTimeMetrics: Codable {
        public let cumulativeForegroundTime: String
        public let cumulativeBackgroundTime: String
        public let cumulativeBackgroundAudioTime: String
        public let cumulativeBackgroundLocationTime: String
    }

    public struct ApplicationResponsivenessMetrics: Codable {
        public let histogrammedAppHangTime: Histogram
    }
}

extension DataItemResponse.Payload.MemoryMetrics {
    public struct AverageSuspendedMemory: Codable {
        public let averageValue: String
        public let sampleCount: Int?
    }
}

extension DataItemResponse.Payload.SignpostMetrics {
    public struct SignpostIntervalData: Codable {
        public let histogrammedSignpostDurations: Histogram
        public let signpostCumulativeCPUTime: String
        public let signpostAverageMemory: String
        public let signpostCumulativeLogicalWrites: String
    }
}

extension DataItemResponse.Payload.DisplayMetrics {
    public struct AveragePixelLuminance: Codable {
        public let averageValue: String
        public let sampleCount: Int?
    }
}
