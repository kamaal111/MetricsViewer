//
//  MetricsLocale.swift
//  
//
//  Created by Kamaal M Farah on 03/07/2021.
//

import SwiftUI

/// MetricsLocale contains keys to localize the app
public struct MetricsLocale {
    private init() { }
}

extension MetricsLocale.Keys {
    /// Returns a localized string
    public var localized: String {
        localized()
    }

    /// Returns a localized string with the variables provided
    /// - Parameter variables: These variables are injected in to the localized string
    /// - Returns: A localized string
    public func localized(with variables: [CVarArg] = []) -> String {
        let bundle = Bundle.module
        switch variables {
        case _ where variables.isEmpty:
            return NSLocalizedString(self.rawValue, bundle: bundle, comment: "")
        default:
            #if DEBUG
            fatalError("Amount of variables are not supported")
            #else
            return NSLocalizedString(key.rawValue, bundle: bundle, comment: "")
            #endif
        }
    }
}
