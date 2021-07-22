//
//  ServiceHostPicker.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 17/07/2021.
//

import SwiftUI
import MetricsLocale

struct ServiceHostPicker: View {
    @Binding var selectedHostName: String

    let hostsNames: [String]
    let onAddPress: () -> Void

    init(selectedHostName: Binding<String>, hostsNames: [String], onAddPress: @escaping () -> Void) {
        self._selectedHostName = selectedHostName
        self.hostsNames = hostsNames
        self.onAddPress = onAddPress
    }

    var body: some View {
        VStack {
            HStack {
                Picker(MetricsLocale.Keys.SERVICE_HOST_PICKER_TITLE.localized, selection: $selectedHostName) {
                    ForEach(hostsNames, id: \.self) { name in
                        Text(name)
                            .tag(name)
                    }
                }
                Button(action: onAddPress) {
                    Image(systemName: "plus")
                }
            }
            if let serviceHostPickerSubText = serviceHostPickerSubText {
                Text(serviceHostPickerSubText)
                    .foregroundColor(.secondary)
                    .font(.footnote)
                    .padding(.top, -8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 12)
    }

    private var serviceHostPickerSubText: String? {
        if hostsNames.isEmpty {
            return MetricsLocale.Keys.SERVICE_HOST_PICKER_SUBTEXT.localized
        }
        return nil
    }
}

struct ServiceHostPicker_Previews: PreviewProvider {
    static var previews: some View {
        ServiceHostPicker(
            selectedHostName: .constant(""),
            hostsNames: ["https://super.io"],
            onAddPress: { })
    }
}
