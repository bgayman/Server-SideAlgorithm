//
//  BiggestSmallestCitiesResponse.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

struct BiggestSmallestCitiesResponse
{
    let state: String
    let biggestCity: CityPopulationResponse
    let smallestCity: CityPopulationResponse
    
    enum Keys: String
    {
        case state
        case biggestCity
        case smallestCity
    }
    
    var dictionary: JSONDictionary
    {
        return [Keys.state.rawValue: state,
                Keys.biggestCity.rawValue: biggestCity.dictionary,
                Keys.smallestCity.rawValue: smallestCity.dictionary]
    }
}

extension BiggestSmallestCitiesResponse
{
    init?(state: State)
    {
        guard let biggestCity = state.largestPopulationCity,
              let smallestCity = state.smallestPopulationCity
        else { return nil }
        self.state = state.abbreviation
        self.biggestCity = CityPopulationResponse(city: biggestCity)
        self.smallestCity = CityPopulationResponse(city: smallestCity)
    }
}
