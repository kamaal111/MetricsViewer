//
//  CoreAppButtonView.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 08/07/2021.
//

import SwiftUI

struct CoreAppButtonView: View {
    @Environment(\.colorScheme)
    private var colorScheme

    let app: CoreApp
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(app.name)
                .font(.title3)
                .bold()
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(backgroundColor)
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var backgroundColor: LinearGradient {
        let secondColor: Color
        if colorScheme == .dark {
            secondColor = .black
        } else {
            secondColor = .white
        }
        let colors: [Color] = [.accentColor, secondColor]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

struct CoreAppButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            if let app = try? PersistenceController.preview.fetch(CoreApp.self).get()?.first {
                CoreAppButtonView(app: app, action: { })
            } else {
                Text("Preview for core app not configured")
            }
        }
        .padding()
        .frame(maxWidth: 300)
    }
}
