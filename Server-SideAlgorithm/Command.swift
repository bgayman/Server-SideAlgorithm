//
//  Command.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/17/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation


extension CommandViewController
{
    // MARK: - Types
    enum Command
    {
        case overTenMillion
        case averageCityPopulation(state: String)
        case biggestSmallestCity(state: String)
        
        var displayString: String
        {
            switch self
            {
            case .overTenMillion:
                return "totalPop10_000_000"
            case .averageCityPopulation(let state):
                return "avgCityPop -\(state)"
            case .biggestSmallestCity(let state):
                return "bigSmallCity -\(state)"
            }
        }
        
        init?(commandSelection: CommandSelection, state: String?)
        {
            switch commandSelection
            {
            case .none:
                return nil
            case .overTenMillion:
                self = Command.overTenMillion
            case .averageCity:
                if let state = state, state != "--"
                {
                    self = Command.averageCityPopulation(state: state)
                }
                else
                {
                    return nil
                }
            case .bigSmallCity:
                if let state = state, state != "--"
                {
                    self = Command.biggestSmallestCity(state: state)
                }
                else
                {
                    return nil
                }
            }
        }
    }
    
    enum CommandSelection: Int
    {
        case none
        case overTenMillion
        case averageCity
        case bigSmallCity
        
        var displayString: String
        {
            switch self
            {
            case .none:
                return "--"
            case .overTenMillion:
                return "totalPop10_000_000"
            case .averageCity:
                return "avgCityPop"
            case .bigSmallCity:
                return "bigSmallCity"
            }
        }
        
        static let all = [CommandSelection.none,
                          CommandSelection.overTenMillion,
                          CommandSelection.averageCity,
                          CommandSelection.bigSmallCity]
    }
}
