//
//  Text+extensions.swift
//  
//
//  Created by Kamaal Farah on 05/07/2021.
//

import MetricsLocale
import SwiftUI

extension Text {
    /// An alternative init to use `Text` with `MetricsLocale Keys`
    /// - Parameters:
    ///   - localized: An localized key to get a localized `Text` view
    ///   - variables: The variables that get injected in to the localized string
    public init(localized: MetricsLocale.Keys, with variables: [CVarArg] = []) {
        self.init(localized.localized(with: variables))
    }
}
