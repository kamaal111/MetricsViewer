//
//  AppDetailsScreen.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 08/07/2021.
//

import SwiftUI

struct AppDetailsScreen: View {
    @EnvironmentObject
    private var coreAppManager: CoreAppManager

    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Background)
        #if os(macOS)
        .navigationTitle(Text(coreAppManager.selectedApp?.name ?? ""))
        #endif
    }
}

struct AppDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailsScreen()
            .environmentObject(CoreAppManager(preview: true))
    }
}
