//
//  String+extensions.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 08/07/2021.
//

import Foundation
import ShrimpExtensions

extension String {
    func replace(_ searchCharacter: Character, with replaceValue: String) -> String {
        self.split(separator: searchCharacter).joined(separator: replaceValue)
    }

    func scramble() -> String {
        self.shuffled().map(\.string).joined(separator: "")
    }
}
