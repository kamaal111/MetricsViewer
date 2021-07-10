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
import XiphiasNet

extension AppDetailsScreen {
    final class ViewModel: ObservableObject {

        @Published private(set) var app: CoreApp? {
            didSet { appDidSet() }
        }
        @Published private(set) var metrics: [DataItemResponse]
        @Published private(set) var metricsLastUpdated: Date?
        @Published var loadingMetrics: Bool
        @Published var showAlert = false
        @Published private(set) var alertMessage: AlertMessage? {
            didSet {
                if !showAlert && alertMessage != nil {
                    showAlert = true
                } else if showAlert && alertMessage == nil {
                    showAlert = false
                }
            }
        }

        init() {
            self.metrics = []
            self.loadingMetrics = false
        }

        private let networker = NetworkController.shared

        var metricsOfLast7Days: [DataItemResponse] {
            let now = Date()
            return metrics.filter({ metric in
                metric.payload.timeStampEnd.isBetween(date: now.adding(days: -7), andDate: now)
            })
        }

        func setApp(_ app: CoreApp) {
            self.app = app
        }

        func getMetrics() {
            guard !loadingMetrics else { return }
            loadingMetrics = true
            guard let app = app else { return }
            networker.getData(from: app.appIdentifier, using: app.accessToken) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let response: [DataItemResponse]
                    switch result {
                    case .failure(let failure):
                        self.handleGetMetricsFailure(failure)
                        self.loadingMetrics = false
                        return
                    case .success(let success): response = success ?? []
                    }
                    self.metrics = response
                    self.metricsLastUpdated = Date()
                    self.loadingMetrics = false
                }
            }
        }

        func handleGetMetricsFailure(_ failure: XiphiasNet.Errors) {
            switch failure {
            case .generalError(error: let error):
                console.log(Date(), failure.localizedDescription, failure, error)
            case let .responseError(message, code):
                switch code {
                case _ where code == 404:
                    // - TODO: Localize this
                    self.alertMessage = AlertMessage(
                        title: "App not found",
                        message: "App has not been registered to use this service")
                case _ where code == 401:
                    // - TODO: Localize this
                    self.alertMessage = AlertMessage(
                        title: "Invalid access token provided",
                        message: "Edit this app with the correct access token")
                default: console.error(Date(), failure.localizedDescription, message, failure)
                }
            case .notAValidJSON:
                console.log(Date(), failure.localizedDescription, failure)
            case .parsingError(error: let error):
                console.log(Date(), failure.localizedDescription, failure, error)
            }
        }

        private func appDidSet() {
            getMetrics()
        }

    }
}
