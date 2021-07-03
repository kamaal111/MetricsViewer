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

    var body: some View {
        NavigationView {
            AppSidebar()
            HomeScreen()
        }
        #if os(macOS)
        .frame(minWidth: 305, minHeight: 305)
        #endif
        .environmentObject(namiNavigator)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(NamiNavigator())
    }
}
