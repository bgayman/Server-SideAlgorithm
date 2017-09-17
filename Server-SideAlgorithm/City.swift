//
//  City.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

// MARK: - City
struct City
{
    let name: String
    let zipCodes: [ZipCode]
    
    var population: Int
    {
        return zipCodes.reduce(0, { $0.0 + $0.1.population })
    }
}

// MARK: - Equatable
extension City: Equatable
{
    static func == (lhs: City, rhs: City) -> Bool
    {
        return lhs.name.lowercased() == rhs.name.lowercased() &&
               lhs.population == rhs.population &&
               lhs.zipCodes == rhs.zipCodes
    }
}

extension City: Comparable
{
    static func < (lhs: City, rhs: City) -> Bool
    {
        return lhs.population < rhs.population
    }
}
