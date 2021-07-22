//
//  ContentView.swift
//  Shared
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject
    private var namiNavigator = NamiNavigator()
    @StateObject
    private var coreAppManager = CoreAppManager()
    @StateObject
    private var coreHostManager = CoreHostManager()

    var body: some View {
        NavigationView {
            AppSidebar()
            switch namiNavigator.selectedScreen {
            case .addApp: AddAppScreen()
            case .appDetails: AppDetailsScreen()
            case .home, nil: HomeScreen()
            }
        }
        .environmentObject(namiNavigator)
        .environmentObject(coreAppManager)
        .environmentObject(coreHostManager)
        #if os(macOS)
        .frame(minWidth: 305, minHeight: 305)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.context!)
            .environmentObject(NamiNavigator())
    }
}
