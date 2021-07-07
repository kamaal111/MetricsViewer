//
//  HomeScreen.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import SwiftUI
import MetricsLocale

struct HomeScreen: View {
    @EnvironmentObject
    private var namiNavigator: NamiNavigator
    @EnvironmentObject
    private var coreAppManager: CoreaAppManager

    @ObservedObject
    private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Button(action: addAppAction) {
                Text(localized: .ADD_APP)
            }
        }
        .onAppear(perform: {
            coreAppManager.fetchAllApps()
        })
        #if os(macOS)
        .toolbar(content: {
            Button(action: addAppAction) {
                Label(MetricsLocale.Keys.ADD_APP.localized, systemImage: "plus")
            }
        })
        #endif
    }

    func addAppAction() {
        namiNavigator.navigate(to: .addApp)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environmentObject(NamiNavigator())
            .environmentObject(CoreaAppManager(preview: true))
    }
}
