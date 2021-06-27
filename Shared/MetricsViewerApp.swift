//
//  MetricsViewerApp.swift
//  Shared
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import SwiftUI

@main
struct MetricsViewerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
