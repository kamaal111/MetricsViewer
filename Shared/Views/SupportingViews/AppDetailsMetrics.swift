//
//  AppDetailsMetrics.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 18/07/2021.
//

import SwiftUI
import SalmonUI

struct AppDetailsMetrics: View {
    @Binding var loadingMetrics: Bool

    let metricsLastUpdated: Date?
    let last7FirstLaunchMetrics: [Double]
    let last7LaunchFromBackgroundMetrics: [Double]

    var body: some View {
        VStack(alignment: .leading) {
            if let metricsLastUpdated = metricsLastUpdated {
                VStack(alignment: .trailing) {
                    Text(localized: .LAST_UPDATED)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    Text(Self.dateFormatter.string(from: metricsLastUpdated))
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.top, -16)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            if loadingMetrics {
                KActivityIndicator(isAnimating: $loadingMetrics, style: .spinning)
            } else {
                LaunchMetricsSection(
                    last7FirstLaunchMetrics: last7FirstLaunchMetrics,
                    last7LaunchFromBackgroundMetrics: last7LaunchFromBackgroundMetrics)
            }
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

struct AppDetailsMetrics_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailsMetrics(
            loadingMetrics: .constant(false),
            metricsLastUpdated: nil,
            last7FirstLaunchMetrics: [],
            last7LaunchFromBackgroundMetrics: [])
    }
}
