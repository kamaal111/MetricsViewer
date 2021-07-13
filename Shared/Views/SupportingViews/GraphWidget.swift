//
//  GraphWidget.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import SwiftUI
import MetricsLocale

struct GraphWidget: View {
    let title: String
    let data: [Double]
    let action: () -> Void

    init(title: String, data: [Double], action: @escaping () -> Void) {
        self.title = title
        self.data = data
        self.action = action
    }

    init(title: MetricsLocale.Keys, data: [Double], action: @escaping () -> Void) {
        self.init(title: title.localized, data: data, action: action)
    }

    private let viewHeight: CGFloat = 140

    var body: some View {
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.headline)
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: viewHeight, maxHeight: viewHeight, alignment: .topLeading)
            .background(Color.secondary)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GraphWidget_Previews: PreviewProvider {
    static var previews: some View {
        GraphWidget(title: "Title", data: [1, 2, 3], action: { })
    }
}
