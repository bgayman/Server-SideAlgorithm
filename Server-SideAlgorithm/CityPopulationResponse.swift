//
//  CityPopulationResponse.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

struct CityPopulationResponse
{
    let name: String
    let population: Int
    
    enum Keys: String
    {
        case name
        case population = "pop"
    }
    
    var dictionary: JSONDictionary
    {
        return [Keys.name.rawValue: name,
                Keys.population.rawValue: population]
    }
}

extension CityPopulationResponse
{
    init(city: City)
    {
        self.name = city.name
        self.population = city.population
    }
}
