//
//  MetricsData.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import Foundation

struct MetricsData {
    let launchTimes: LaunchTimes?

    struct LaunchTimes {
        let averageFirstLaunch: Int?
        let averageLaunchFromBackground: Int?
    }
}
