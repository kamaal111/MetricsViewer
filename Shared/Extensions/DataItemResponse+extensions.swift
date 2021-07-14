//
//  DataItemResponse+extensions.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import MetricsNetworker

extension DataItemResponse {
    var toMetricsData: MetricsData {
        let payload = self.payload
        return MetricsData(
            startDate: payload.timeStampBegin,
            endDate: payload.timeStampEnd,
            launchTimes: launchTimes,
            gpuMetrics: gpuMetrics)
    }

    private var launchTimes: MetricsData.LaunchTimes? {
        guard let applicationLaunchMetrics = self.payload.applicationLaunchMetrics else { return nil }
        let averageFirstLaunch = applicationLaunchMetrics.histogrammedTimeToFirstDrawKey?.averageValue
        let averageLaunchFromBackground = applicationLaunchMetrics.histogrammedResumeTime?.averageValue
        return MetricsData.LaunchTimes(
            averageFirstLaunch: averageFirstLaunch,
            averageLaunchFromBackground: averageLaunchFromBackground)
    }

    private var gpuMetrics: MetricsData.GPUMetrics? {
        guard let gpuMetrics = self.payload.gpuMetrics else { return nil }
        let totalGPUTime = Double(gpuMetrics.cumulativeGPUTime.digits) ?? 0
        return MetricsData.GPUMetrics(totalGPUTime: totalGPUTime)
    }
}
