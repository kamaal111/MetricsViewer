//
//  AlertMessageError.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 17/07/2021.
//

import Foundation

protocol AlertMessageError: Error {
    var alertMessage: AlertMessage { get }
}
