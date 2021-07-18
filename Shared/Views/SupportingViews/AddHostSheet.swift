//
//  AddHostSheet.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 17/07/2021.
//

import SwiftUI
import SalmonUI
import MetricsUI
import MetricsLocale

struct AddHostSheet: View {
    @Binding var name: String
    @Binding var urlString: String

    let onSave: () -> Void
    let onClose: () -> Void

    var body: some View {
        KSheetStack(title: MetricsLocale.Keys.ADD_SERVICE_HOST.localized, leadingNavigationButton: {
            Button(action: onClose) {
                Text(localized: .CLOSE)
            }
        }, trailingNavigationButton: {
            Button(action: onSave) {
                Text(localized: .SAVE)
            }
        }) {
            VStack {
                FloatingTextFieldWithSubtext(
                    text: $name,
                    title: .SERVICE_NAME_FORM_TITLE,
                    subtext: .SERVICE_NAME_FORM_SUBTEXT)
                KFloatingTextField(text: $urlString, title: .SERVICE_URL_FORM_TITLE)
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
