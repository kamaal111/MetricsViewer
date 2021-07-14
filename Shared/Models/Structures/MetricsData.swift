//
//  MetricsData.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import Foundation

struct MetricsData {
    let startDate: Date
    let endDate: Date
    let launchTimes: LaunchTimes?
    let gpuMetrics: GPUMetrics?

    struct LaunchTimes {
        let averageFirstLaunch: Double?
        let averageLaunchFromBackground: Double?
    }

    struct GPUMetrics {
        let totalGPUTime: Double
    }
}
