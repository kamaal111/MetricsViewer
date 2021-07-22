//
//  CoreHostManager.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 22/07/2021.
//

import Foundation
import PersistanceManager
import ConsoleSwift

final class CoreHostManager: ObservableObject {

    @Published private(set) var hosts: [CoreHost] = []

    private let persistenceController: PersistanceManager

    init(preview: Bool = false) {
        if !preview {
            self.persistenceController = PersistenceController.shared
        } else {
            self.persistenceController = PersistenceController.preview
        }
    }

    func addHost(_ host: CoreHost) {
        hosts.append(host)
    }

    func fetchAllHosts() {
        let hostsResult = persistenceController.fetch(CoreHost.self)
        let hosts: [CoreHost]
        switch hostsResult {
        case .failure(let failure):
            console.error(Date(), failure.localizedDescription, failure)
            return
        case .success(let success): hosts = success ?? []
        }
        self.hosts = hosts
    }

}
