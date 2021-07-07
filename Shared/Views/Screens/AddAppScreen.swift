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
    @EnvironmentObject
    private var namiNavigator: NamiNavigator

    @ObservedObject
    private var viewModel = ViewModel()

    var body: some View {
        VStack {
            KFloatingTextField(text: $viewModel.appName, title: .APP_NAME_FORM_TITLE)
            FloatingTextFieldWithSubtext(
                text: $viewModel.appIdentifier,
                title: .APP_IDENTIFIER_FORM_TITLE,
                subtext: .APP_IDENTIFIER_FORM_SUBTEXT)
            KFloatingTextField(text: $viewModel.accessToken, title: .ACCESS_TOKEN_FORM_TITLE)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .alert(isPresented: $viewModel.showAlert, content: alert)
        #if os(macOS)
        .navigationTitle(Text(localized: .ADD_APP))
        .toolbar(content: {
            Button(action: {
                if let savedApp = viewModel.onDoneEditing() {
                    namiNavigator.navigate(to: nil)
                }
            }) {
                Text(localized: .DONE)
            }
        })
        #endif
    }

    private func alert() -> Alert {
        guard let alertMessage = viewModel.alertMessage else {
            return Alert(title: Text(localized: .GENERAL_ALERT_TITLE))
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
