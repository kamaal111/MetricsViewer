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
    let action: () -> Void

    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    init(title: MetricsLocale.Keys, action: @escaping () -> Void) {
        self.init(title: title.localized, action: action)
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
        GraphWidget(title: "Title", action: { })
    }
}
