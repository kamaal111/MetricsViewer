//
//  DateValueCodable.swift
//  
//
//  Created by Kamaal M Farah on 10/07/2021.
//

import Foundation

/// An wrapper protocol arround `Codable` to decode dates, mainly used in ``DateValueCodable`` property wrapper.
public protocol DateValueCodableStrategy {
    /// The type that gets decoded or get encoded to.
    associatedtype RawValue: Codable
    /// Decodes an `Codable` of the given `associatedtype` to an `Date`.
    /// - Returns: an `Date`
    static func decode(_ value: RawValue) throws -> Date
    /// Encodes an given `Date` and decodes it to the given `associatedtype`.
    /// - Returns: the encoded value of the `associatedtype`
    static func encode(_ date: Date) -> RawValue
}

/// This property wrapper formats an string decoded from an `Codable` property to an `Date` object
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

/// Strategy to decode from `yyyy-MM-dd HH:mm:ss +SSSS` or `yyyy-MM-dd HH:mm:ss a +SSSS`
public struct MetricsDateCodableStrategy: DateValueCodableStrategy {
    private static let formats = [
        "yyyy-MM-dd HH:mm:ss +SSSS",
        "yyyy-MM-dd HH:mm:ss a +SSSS"
    ]

    public static func decode(_ value: String) throws -> Date {
        let formatter = DateFormatter()
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: value) {
                return date
            }
        }
        throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid date format: \(value)"))
    }

    public static func encode(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formats[0]
        return formatter.string(from: date)
    }
}
