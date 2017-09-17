//
//  AverageCityPopulationResponse.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

struct AverageCityPopulationResponse
{
    let state: String
    let averageCityPopulation: Int
    
    enum Keys: String
    {
        case state = "_id"
        case averageCityPopulation = "avgCityPop"
    }
    
    var dictionary: JSONDictionary
    {
        return [Keys.state.rawValue: state,
                Keys.averageCityPopulation.rawValue: averageCityPopulation]
    }
}

extension AverageCityPopulationResponse
{
    init(state: State)
    {
        self.state = state.abbreviation
        self.averageCityPopulation = state.avarageCityPopulation
    }
}
