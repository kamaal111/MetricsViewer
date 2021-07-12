//
//  DateValueCodable.swift
//  
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import Foundation

#warning("Document this")

/// An wrapper protocol arround `Codable` to decode dates, mainly used in ``DateValueCodable`` property wrapper.
public protocol DateValueCodableStrategy {
    associatedtype RawValue: Codable
    static func decode(_ value: RawValue) throws -> Date
    static func encode(_ date: Date) -> RawValue
}

/// This property wrapper formats an string decoded from an `Codable` property to an `Swift` `Date` object
@propertyWrapper
public struct DateValueCodable<Formatter: DateValueCodableStrategy>: Codable {
    private let value: Formatter.RawValue
    public var wrappedValue: Date

    public init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
        self.value = Formatter.encode(wrappedValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(Formatter.RawValue.self)
        self.wrappedValue = try Formatter.decode(value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Formatter.encode(wrappedValue))
    }
}

public struct MetricsDateCodableStrategy: DateValueCodableStrategy {
    public typealias RawValue = String

    private static let formats = [
        "yyyy-MM-dd HH:mm:ss +SSSS",
        "yyyy-MM-dd HH:mm:ss a +SSSS"
    ]

    public static func decode(_ value: String) throws -> Date {
        try formatDateString(with: formats, value: value)
    }

    public static func encode(_ date: Date) -> String {
        formatDateToString(with: formats[0], date: date)
    }
}

private func formatDateString(with formats: [String], value: String) throws -> Date {
    let formatter = DateFormatter()
    for format in formats {
        formatter.dateFormat = format
        if let date = formatter.date(from: value) {
            return date
        }
    }
    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid date format: \(value)"))
}

private func formatDateToString(with format: String, date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}
