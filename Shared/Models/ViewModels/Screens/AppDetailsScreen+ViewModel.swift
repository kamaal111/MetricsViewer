//
//  AppDetailsScreen+ViewModel.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import Foundation
import Combine
import ConsoleSwift
import MetricsNetworker

extension AppDetailsScreen {
    final class ViewModel: ObservableObject {

        @Published private(set) var app: CoreApp? {
            didSet { appDidSet() }
        }
        @Published private(set) var metrics: [DataItemResponse]
        @Published private(set) var metricsLastUpdated: Date?
        @Published var loadingMetrics: Bool

        init() {
            self.metrics = []
            self.loadingMetrics = false
        }

        private let networker = NetworkController.shared

        func setApp(_ app: CoreApp) {
            self.app = app
        }

        func getMetrics() {
            guard !loadingMetrics else { return }
            loadingMetrics = true
            guard let app = app else { return }
            networker.getData(from: app.appIdentifier, using: app.accessToken) { [weak self] result in
                let response: [DataItemResponse]
                switch result {
                case .failure(let failure):
                    console.error(Date(), failure.localizedDescription, failure)
                    self?.loadingMetrics = false
                    return
                case .success(let success): response = success ?? []
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.metrics = response
                    self.metricsLastUpdated = Date()
                    self.loadingMetrics = false
                }
            }
        }

        private func appDidSet() {
            getMetrics()
        }

    }
}
