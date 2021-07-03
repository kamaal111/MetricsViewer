//
//  AddAppScreen.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 29/06/2021.
//

import SwiftUI
import SalmonUI
import MetricsUI

struct AddAppScreen: View {
    @ObservedObject
    private var viewModel = ViewModel()

    var body: some View {
        VStack {
            // - TODO: LOCALIZE THIS
            KFloatingTextField(text: $viewModel.appName, title: "App Name")
            FloatingTextFieldWithSubtext(
                text: $viewModel.appIdentifier,
                // - TODO: LOCALIZE THIS
                title: "App Identifier",
                // - TODO: LOCALIZE THIS
                subtext: "example: com.domain.appName")
            KFloatingTextField(text: $viewModel.accessToken, title: "Access Token")
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        #if os(macOS)
        // - TODO: LOCALIZE THIS
        .navigationTitle(Text("Add App"))
        .toolbar(content: {
            Button(action: {
                print("done")
            }) {
                Text("Done")
            }
        })
        #endif
    }
}

struct AddAppScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddAppScreen()
    }
}
