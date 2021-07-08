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
    private var coreAppManager: CoreAppManager

    @ObservedObject
    private var viewModel = ViewModel()

    var body: some View {
        VStack {
            if coreAppManager.apps.isEmpty {
                Button(action: addAppAction) {
                    Text(localized: .ADD_APP)
                }
            } else {
                // - TODO: Localize this
                Text("Apps")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(coreAppManager.apps, id: \.self) { (app: CoreApp) in
                    CoreAppButtonView(app: app)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 4)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: viewAlignment)
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

    private var viewAlignment: Alignment {
        if coreAppManager.apps.isEmpty {
            return .center
        }
        return .topLeading
    }

    private func addAppAction() {
        namiNavigator.navigate(to: .addApp)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environmentObject(NamiNavigator())
            .environmentObject(CoreAppManager(preview: true))
    }
}
