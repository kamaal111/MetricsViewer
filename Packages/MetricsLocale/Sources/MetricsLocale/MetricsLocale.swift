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

    static func getLocalizableString(of key: Keys, with variables: [CVarArg]) -> String {
        let bundle = Bundle.module
        let keyRawValue = key.rawValue
        switch variables {
        case _ where variables.isEmpty:
            return NSLocalizedString(keyRawValue, bundle: bundle, comment: "")
        default:
            #if DEBUG
            fatalError("Amount of variables are not supported")
            #else
            return NSLocalizedString(keyRawValue, bundle: bundle, comment: "")
            #endif
        }
    }
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
        MetricsLocale.getLocalizableString(of: self, with: variables)
    }
}
