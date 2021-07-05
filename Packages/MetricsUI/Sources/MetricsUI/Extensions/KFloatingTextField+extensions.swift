//
//  KFloatingTextField+extensions.swift
//  
//
//  Created by Kamaal M Farah on 03/07/2021.
//

import SalmonUI
import MetricsLocale
import SwiftUI

extension KFloatingTextField {
    /// An alternative init to use `KFloatingTextField` with `MetricsLocale Keys`
    /// - Parameters:
    ///   - text: An `Binding` string for the text in the text field
    ///   - title: An localized key to get a localized `KFloatingTextField` view
    public init(text: Binding<String>, title: MetricsLocale.Keys) {
        self.init(text: text, title: title.localized)
    }
}
