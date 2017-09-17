//
//  JSONDictionary.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

extension Dictionary where Key: ExpressibleByStringLiteral
{
    func string() throws -> String?
    {
        let data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
        return String(data: data, encoding: .utf8)
    }
}

