//
//  String+extensions.swift
//  
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import Foundation

extension String {
    var digits: String {
        components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
