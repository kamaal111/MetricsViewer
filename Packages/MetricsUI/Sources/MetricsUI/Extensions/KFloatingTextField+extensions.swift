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
    public init(text: Binding<String>, title: MetricsLocale.Keys) {
        self.init(text: text, title: title.localized)
    }
}
