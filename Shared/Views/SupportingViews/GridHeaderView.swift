//
//  GridHeaderView.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 08/07/2021.
//

import SwiftUI

struct GridHeaderView: View {
    @Environment(\.colorScheme)
    private var colorScheme

    let viewWidth: CGFloat
    let horizontalPadding: CGFloat
    let headerTitles: [String]

    init(viewWidth: CGFloat, headerTitles: [String], horizontalPadding: CGFloat = 8) {
        self.viewWidth = viewWidth
        self.headerTitles = headerTitles
        self.horizontalPadding = horizontalPadding
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(headerTitles, id: \.self) { headerTitle in
                Text(headerTitle)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)
                    .frame(width: headerWidth, alignment: .leading)
                    .background(backgroundColor)
                    .padding(.horizontal, horizontalPadding)
            }
        }
    }

    // - TODO: PUT THIS IN SOME GENERIC COLOR
    private var backgroundColor: Color {
        switch colorScheme {
        case .dark: return .black
        case .light: return .white
        @unknown default: return .black
        }
    }

    private var headerWidth: CGFloat {
        guard viewWidth > 0 else { return 0 }
        let calculation = (viewWidth / CGFloat(headerTitles.count)) - (horizontalPadding * 2)
        guard calculation > 0 else { return 0 }
        return calculation
    }
}

struct GridHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GridHeaderView(viewWidth: 300, headerTitles: [
            "Name",
            "Shares",
            "Price"
        ])
    }
}
