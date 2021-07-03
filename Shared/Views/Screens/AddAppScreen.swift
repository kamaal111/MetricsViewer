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
        .alert(isPresented: $viewModel.showAlert, content: alert)
        #if os(macOS)
        // - TODO: LOCALIZE THIS
        .navigationTitle(Text("Add App"))
        .toolbar(content: {
            Button(action: viewModel.onDoneEditing) {
                // - TODO: LOCALIZE THIS
                Text("Done")
            }
        })
        #endif
    }

    private func alert() -> Alert {
        guard let alertMessage = viewModel.alertMessage else {
            // - TODO: LOCALIZE THIS
            return Alert(title: Text("Something went wrong"))
        }
        var messageText: Text?
        if let message = alertMessage.message {
            messageText = Text(message)
        }
        return Alert(title: Text(alertMessage.title), message: messageText)
    }
}

struct AddAppScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddAppScreen()
    }
}
