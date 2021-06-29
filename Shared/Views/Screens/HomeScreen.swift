//
//  HomeScreen.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 27/06/2021.
//

import SwiftUI
import Combine

struct HomeScreen: View {
    @EnvironmentObject
    var namiNavigator: NamiNavigator

    @ObservedObject
    private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Button(action: {
                namiNavigator.showAddAppScreen = true
            }) {
                // - TODO: Localize this
                Text("Add App")
            }
        }
        .toolbar(content: {
            Button(action: {
                namiNavigator.showAddAppScreen = true
            }) {
                // - TODO: Localize this
                Label("Add App", systemImage: "plus")
            }
        })
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
            .environmentObject(NamiNavigator())
    }
}
