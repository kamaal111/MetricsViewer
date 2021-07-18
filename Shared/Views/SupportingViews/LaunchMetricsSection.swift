//
//  LaunchMetricsSection.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 18/07/2021.
//

import SwiftUI

struct LaunchMetricsSection: View {
    let last7FirstLaunchMetrics: [Double]
    let last7LaunchFromBackgroundMetrics: [Double]

    var body: some View {
        VStack(alignment: .leading) {
            Text(localized: .LAUNCH_TIMES_SECTION_TITLE)
                .font(.title2)
                .bold()
            HStack {
                GraphWidget(
                    title: .LAUNCH_TIMES_FIRST_LAUNCH_HEADER,
                    data: last7FirstLaunchMetrics,
                    action: {
                    print("first", last7FirstLaunchMetrics)
                })
                    .padding(.trailing, 8)
                GraphWidget(
                    title: .LAUNCH_TIMES_LAUNCH_FROM_BACKGROUND_HEADER,
                    data: last7LaunchFromBackgroundMetrics,
                    action: {
                    print("second", last7LaunchFromBackgroundMetrics)
                })
                    .padding(.leading, 8)
            }
        }
    }
}

struct LaunchMetricsSection_Previews: PreviewProvider {
    static var previews: some View {
        LaunchMetricsSection(last7FirstLaunchMetrics: [], last7LaunchFromBackgroundMetrics: [])
    }
}
