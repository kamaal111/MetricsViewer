//
//  AddHostSheet.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 17/07/2021.
//

import SwiftUI
import SalmonUI
import MetricsUI

struct AddHostSheet: View {
    @Binding var name: String
    @Binding var urlString: String

    let onSave: () -> Void
    let onClose: () -> Void

    var body: some View {
        // - TODO: LOCALIZE THIS
        KSheetStack(title: "Add service host", leadingNavigationButton: {
            Button(action: onSave) {
                // - TODO: LOCALIZE THIS
                Text("Save")
            }
        }, trailingNavigationButton: {
            Button(action: onClose) {
                // - TODO: LOCALIZE THIS
                Text("Close")
            }
        }) {
            VStack {
                FloatingTextFieldWithSubtext(
                    text: $name,
                    // - TODO: LOCALIZE THIS
                    title: "Service name",
                    // - TODO: LOCALIZE THIS
                    subtext: "This name helps you choose the host, you could also just give it the url of the metrics service")
                // - TODO: LOCALIZE THIS
                KFloatingTextField(text: $urlString, title: "Service URL")
            }
            .padding(.vertical, 16)
        }
        .frame(minWidth: 400)
    }
}

struct AddHostSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddHostSheet(name: .constant(""), urlString: .constant(""), onSave: { }, onClose: { })
    }
}
