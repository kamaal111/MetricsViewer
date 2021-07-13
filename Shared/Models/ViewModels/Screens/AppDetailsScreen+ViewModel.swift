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
        @Published private(set) var metrics: [MetricsData]
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

        var last7RecordedMetrics: Array<MetricsData>.SubSequence {
            let groupedMetrics = Dictionary(grouping: metrics, by: \.endDate)
            let metrics = groupedMetrics
                .sorted(by: { dict1, dict2 in
                    dict1.key.compare(dict2.key) == .orderedAscending
                })
                .flatMap(\.value)
                .suffix(7)
            return metrics
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
                    self.metrics = response.map(\.toMetricsData)
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
                    self.alertMessage = AlertMessage(
                        title: .APP_NOT_FOUND_ALERT_TITLE,
                        message: .APP_NOT_FOUND_ALERT_MESSAGE)
                case _ where code == 401:
                    self.alertMessage = AlertMessage(
                        title: .INVALID_ACCESS_TOKEN_ALERT_TITLE,
                        message: .INVALID_ACCESS_TOKEN_ALERT_MESSAGE)
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
