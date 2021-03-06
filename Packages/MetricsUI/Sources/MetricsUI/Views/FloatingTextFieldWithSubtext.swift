//
//  FloatingTextFieldWithSubtext.swift
//  
//
//  Created by Kamaal M Farah on 03/07/2021.
//

import SwiftUI
import SalmonUI
import MetricsLocale

public struct FloatingTextFieldWithSubtext: View {
    @Binding public var text: String

    public let title: String
    public let subtext: String

    public init(text: Binding<String>, title: String, subtext: String) {
        self._text = text
        self.title = title
        self.subtext = subtext
    }

    public init(text: Binding<String>, title: MetricsLocale.Keys, subtext: MetricsLocale.Keys) {
        self.init(text: text, title: title.localized, subtext: subtext.localized)
    }

    public init(text: Binding<String>, title: MetricsLocale.Keys, subtext: String) {
        self.init(text: text, title: title.localized, subtext: subtext)
    }

    public init(text: Binding<String>, title: String, subtext: MetricsLocale.Keys) {
        self.init(text: text, title: title, subtext: subtext.localized)
    }

    public var body: some View {
        VStack {
            KFloatingTextField(text: $text, title: title)
            Text(subtext)
                .foregroundColor(.secondary)
                .font(.footnote)
                .padding(.top, -8)
                .padding(.leading, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct FloatingTextFieldWithSubtext_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FloatingTextFieldWithSubtext(text: .constant(""), title: "Tile", subtext: "example")
                .previewLayout(.sizeThatFits)
                .padding(.vertical, 20)
            FloatingTextFieldWithSubtext(text: .constant(""), title: "Tile", subtext: "example")
                .previewLayout(.sizeThatFits)
                .padding(.vertical, 20)
                .colorScheme(.dark)
                .background(Color.black)
        }
    }
}
