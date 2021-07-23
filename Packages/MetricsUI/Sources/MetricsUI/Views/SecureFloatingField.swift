//
//  SecureFloatingField.swift
//  
//
//  Created by Kamaal M Farah on 22/07/2021.
//

import SwiftUI
import SalmonUI
import MetricsLocale

@available(macOS 11.0, *)
public struct SecureFloatingField: View {
    @State private var showText = false

    @Binding public var text: String

    public let title: String

    public init(text: Binding<String>, title: String) {
        self._text = text
        self.title = title
    }

    public init(text: Binding<String>, title: MetricsLocale.Keys) {
        self.init(text: text, title: title.localized)
    }

    public var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(textColor)
                    .offset(y: $text.wrappedValue.isEmpty ? 0 : -25)
                    .scaleEffect($text.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
                    .padding(.horizontal, titleHorizontalPadding)
                if showText {
                    TextField(titleText, text: $text)
                } else {
                    SecureField(titleText, text: $text)
                }
            }
            .padding(.top, 12)
            .animation(.spring(response: 0.5))
            Button(action: { showText.toggle() }) {
                Image(systemName: "eye")
            }
            .padding(.top, 12)
        }
    }

    private var titleText: String {
        #if canImport(UIKit)
        ""
        #else
        title
        #endif
    }

    private var textColor: Color {
        if $text.wrappedValue.isEmpty {
            return .secondary
        }
        return .accentColor
    }

    private var titleHorizontalPadding: CGFloat {
        if $text.wrappedValue.isEmpty {
            return 4
        }
        return 0
    }
}

@available(macOS 11.0, *)
struct SecureFloatingField_Previews: PreviewProvider {
    static var previews: some View {
        SecureFloatingField(text: .constant("yes"), title: "secure")
    }
}
