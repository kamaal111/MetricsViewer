//
//  AppDetailsScreen.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 08/07/2021.
//

import SwiftUI
import MetricsLocale

struct AppDetailsScreen: View {
    @EnvironmentObject
    private var coreAppManager: CoreAppManager

    @ObservedObject
    private var viewModel: ViewModel

    private let preview: Bool

    init(preview: Bool = false) {
        self.preview = preview
        self.viewModel = ViewModel(preview: true)
    }

    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.editScreenIsActive {
                ModifyApp(
                    appName: $viewModel.editingAppName,
                    appIdentifier: $viewModel.editingAppIdentifier,
                    accessToken: $viewModel.editingAccessToken,
                    selectedHost: $viewModel.editingSelectedHost,
                    preview: preview)
            } else {
                AppDetailsMetrics(
                    loadingMetrics: $viewModel.loadingMetrics,
                    metricsLastUpdated: viewModel.metricsLastUpdated,
                    last7FirstLaunchMetrics: viewModel.last7FirstLaunchMetrics,
                    last7LaunchFromBackgroundMetrics: viewModel.last7LaunchFromBackgroundMetrics)
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
            ToolbarItem(content: {
                Button(action: viewModel.onEditPress) {
                    Text(localized: viewModel.editScreenIsActive ? .DONE : .EDIT)
                        .animation(nil)
                }
            })
            ToolbarItem(content: {
                Button(action: viewModel.getMetrics) {
                    Label(MetricsLocale.Keys.REFRESH_METRICS.localized, systemImage: "arrow.triangle.2.circlepath")
                }
                .disabled(viewModel.loadingMetrics)
            })
        })
        #endif
    }

    private func onViewAppear() {
        if let selectedApp = coreAppManager.selectedApp {
            viewModel.setApp(selectedApp)
        }
    }
}

struct AppDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailsScreen()
            .environmentObject(CoreAppManager(preview: true))
    }
}
