//
//  StatePopulationResponse.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

struct  StatePopulationResponse
{
    let state: String
    let population: Int
    
    enum Keys: String
    {
        case state = "_id"
        case population = "totalPop"
    }
    
    var dictionary: JSONDictionary
    {
        return [Keys.state.rawValue: state,
                Keys.population.rawValue: population]
    }
}

extension StatePopulationResponse
{
    init(state: State)
    {
        self.state = state.abbreviation
        self.population = state.population
    }
}
