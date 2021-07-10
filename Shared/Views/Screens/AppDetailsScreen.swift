//
//  AppDetailsScreen.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 08/07/2021.
//

import SwiftUI
import SalmonUI

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
                // - TODO: Localize this
                Text("Last updated")
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
                // - TODO: Localize this
                Text("Launch Times")
                    .font(.title2)
                    .bold()
                HStack {
                    // - TODO: Localize this
                    GraphWidget(title: "First launch", action: {
                        print("first")
                    })
                        .padding(.trailing, 8)
                    // - TODO: Localize this
                    GraphWidget(title: "Launch from background", action: {
                        print("second")
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
                // - TODO: Localize this
                Label("Refresh metrics", systemImage: "arrow.triangle.2.circlepath")
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