//
//  Date+extensions.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import Foundation

extension Date {
    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}
