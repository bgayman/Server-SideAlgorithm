//
//  ZipCode.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

// MARK: - ZipCode
struct ZipCode
{
    let id: String
    let city: String
    let state: String
    let population: Int
    let location: Location
    
    enum Keys: String
    {
        case id = "_id"
        case city
        case state
        case population = "pop"
        case location = "loc"
    }
}

// MARK: - ZipCode - Init
extension ZipCode
{
    init?(dictionary: JSONDictionary)
    {
        guard let id = dictionary[Keys.id.rawValue] as? String,
              let city = dictionary[Keys.city.rawValue] as? String,
              let state = dictionary[Keys.state.rawValue] as? String,
              let population = dictionary[Keys.population.rawValue] as? Int,
              let locationValue = dictionary[Keys.location.rawValue] as? [Double],
              let location = Location(array: locationValue)
        else { return nil }
        
        self.id = id
        self.city = city
        self.state = state
        self.population = population
        self.location = location
    }
}

// MARK: - ZipCode - Equatable
extension ZipCode: Equatable
{
    static func == (lhs: ZipCode, rhs: ZipCode) -> Bool
    {
        return lhs.id == rhs.id
    }
}

// MARK: - Location
struct Location
{
    let latitude: Double
    let longitude: Double
    
    enum Subscripts: Int
    {
        case latitude
        case longitude
    }
}

// MARK: - Location - Init
extension Location
{
    init?(array: [Double])
    {
        guard array.count == 2 else { return nil }
        
        self.latitude = array[Subscripts.latitude.rawValue]
        self.longitude = array[Subscripts.longitude.rawValue]
    }
}
