//
//  SecureFloatingField.swift
//  
//
//  Created by Kamaal M Farah on 22/07/2021.
//

import SwiftUI
import SalmonUI

struct SecureFloatingField: View {
    #error("USE THIS SHOW TEXT TO TOGGLE AND USE THIS VIEW IN MODIFY APP TO HIDE ACCESS TOKEN")
    @State private var showText = false

    @Binding public var text: String

    public let title: String

    public init(text: Binding<String>, title: String) {
        self._text = text
        self.title = title
    }

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(textColor)
                    .offset(y: $text.wrappedValue.isEmpty ? 0 : -25)
                    .scaleEffect($text.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
                    .padding(.horizontal, titleHorizontalPadding)
                #if canImport(UIKit)
                SecureField("", text: $text)
                #else
                SecureField(title, text: $text)
                #endif
            }
            .padding(.top, 12)
            .animation(.spring(response: 0.5))
        }
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

struct SecureFloatingField_Previews: PreviewProvider {
    static var previews: some View {
        SecureFloatingField(text: .constant("yes"), title: "secure")
    }
}
