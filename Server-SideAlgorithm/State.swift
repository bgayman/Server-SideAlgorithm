//
//  State.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

struct State
{
    let abbreviation: String
    let cities: [City]
    
    init(abbreviation: String, zipCodes: [ZipCode])
    {
        self.abbreviation = abbreviation
        
        var citiesDict = [String: [ZipCode]]()
        for zip in zipCodes
        {
            if var cityZipCodes = citiesDict[zip.city]
            {
                cityZipCodes.append(zip)
                citiesDict[zip.city] = cityZipCodes
            }
            else
            {
                citiesDict[zip.city] = [zip]
            }
        }
        
        self.cities = citiesDict.map(City.init).sorted()
    }
    
    var population: Int
    {
        return cities.flatMap{ $0.zipCodes }.reduce(0, { $0.0 + $0.1.population })
    }
    
    var avarageCityPopulation: Int
    {
        return cities.reduce(0, { $0.0 + $0.1.population}) / cities.count
    }
    
    var smallestPopulationCity: City?
    {
        return cities.first
    }
    
    var largestPopulationCity: City?
    {
        return cities.last
    }
}

extension State: Equatable
{
    static func == (lhs: State, rhs: State) -> Bool
    {
        return lhs.abbreviation.lowercased() == rhs.abbreviation.lowercased()
    }
}

extension State: Comparable
{
    static func < (lhs: State, rhs: State) -> Bool
    {
        return lhs.population > rhs.population
    }
}
