//
//  LYDecimalNumber.swift
//  LYNetworkService
//
//  Created by dong on 2022/11/30.
//

import UIKit
@propertyWrapper
public struct LYDecimalNumber {
    private let value: String
    public var wrappedValue: NSDecimalNumber

   public init(wrappedValue: NSDecimalNumber) {
        self.wrappedValue = wrappedValue
        value = wrappedValue.stringValue
    }
}


extension LYDecimalNumber: Decodable {
    public init(from decoder: Decoder) throws {
        value = try String(from: decoder)
        wrappedValue = NSDecimalNumber(string: value)
    }
}

extension LYDecimalNumber: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue.stringValue)
    }
}

extension LYDecimalNumber: Equatable {}
