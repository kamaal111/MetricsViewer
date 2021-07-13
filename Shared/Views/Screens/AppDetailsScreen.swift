//
//  AppDetailsScreen.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 08/07/2021.
//

import SwiftUI
import SalmonUI
import MetricsLocale

struct AppDetailsScreen: View {
    @EnvironmentObject
    private var coreAppManager: CoreAppManager

    @ObservedObject
    private var viewModel: ViewModel

    init() {
        self.viewModel = ViewModel()
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .trailing) {
                Text(localized: .LAST_UPDATED)
                    .foregroundColor(.secondary)
                    .font(.caption)
                if let metricsLastUpdated = viewModel.metricsLastUpdated {
                    Text(Self.dateFormatter.string(from: metricsLastUpdated))
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .padding(.top, -16)
            .frame(maxWidth: .infinity, alignment: .trailing)
            if viewModel.loadingMetrics {
                KActivityIndicator(isAnimating: $viewModel.loadingMetrics, style: .spinning)
            } else {
                Text(localized: .LAUNCH_TIMES_SECTION_TITLE)
                    .font(.title2)
                    .bold()
                HStack {
                    GraphWidget(
                        title: .LAUNCH_TIMES_FIRST_LAUNCH_HEADER,
                        data: viewModel.last7FirstLaunchMetrics,
                        action: {
                        print("first", viewModel.last7FirstLaunchMetrics)
                    })
                        .padding(.trailing, 8)
                    GraphWidget(
                        title: .LAUNCH_TIMES_LAUNCH_FROM_BACKGROUND_HEADER,
                        data: viewModel.last7LaunchFromBackgroundMetrics,
                        action: {
                        print("second", viewModel.last7LaunchFromBackgroundMetrics)
                    })
                        .padding(.leading, 8)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.Background)
        .onAppear(perform: onViewAppear)
        .alert(isPresented: $viewModel.showAlert, content: { handledAlert(with: viewModel.alertMessage) })
        #if os(macOS)
        .navigationTitle(Text(viewModel.app?.name ?? ""))
        .toolbar(content: {
            Button(action: viewModel.getMetrics) {
                Label(MetricsLocale.Keys.REFRESH_METRICS.localized, systemImage: "arrow.triangle.2.circlepath")
            }
            .disabled(viewModel.loadingMetrics)
        })
        #endif
    }

    private func onViewAppear() {
        if let selectedApp = coreAppManager.selectedApp {
            viewModel.setApp(selectedApp)
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

struct AppDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailsScreen()
            .environmentObject(CoreAppManager(preview: true))
    }
}
