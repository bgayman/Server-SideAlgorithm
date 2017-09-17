//
//  ZipCodeCalculator.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

// MARK: - ZipCodeCalculator
struct ZipCodeCalculator
{
    // MARK: - Types
    enum ZipCodeCalculatorError: Error
    {
        case invalidParameter
        case stateNotFound
    }
    
    // MARK: - Properties
    let states: [State]
    
    var greaterThanTenMillionResponse: String
    {
        // Convert states with population over 10,000,000 to response formatted JSON Strings
        let strings = states(populationGreaterThan: 10_000_000)
                      .map(StatePopulationResponse.init)
                      .map { $0.dictionary }
                      .flatMap { try? $0.string() }
                      .flatMap { $0 }
        
        // Have each JSON String begin on it's own line
        return strings.joined(separator: "\n")
    }
    
    // MARK: - Lifecycle
    init(states: [State])
    {
        self.states = states.sorted()
    }
    
    // MARK: - Public Functions
    func averagePopulationResponse(forState abbreviation: String) throws -> String?
    {
        let state = try self.state(for: abbreviation)
        let responseDictionary = AverageCityPopulationResponse(state: state).dictionary
        let responseString = try responseDictionary.string()
        return responseString
    }
    
    func biggestSmallestCities(forState abbreviation: String) throws -> String?
    {
        let state = try self.state(for: abbreviation)
        let responseDictionary = BiggestSmallestCitiesResponse(state: state)?.dictionary
        let responseString = try responseDictionary?.string()
        return responseString
    }
    
    // MARK: - Helpers
    func state(for abbreviation: String) throws -> State
    {
        let stateString = abbreviation.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard stateString.characters.count == 2,
            stateString.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil else
        {
            throw ZipCodeCalculatorError.invalidParameter
        }
        guard let state = self.states.first(where: { $0.abbreviation.lowercased() == stateString.lowercased() }) else
        {
            throw ZipCodeCalculatorError.stateNotFound
        }
        return state
    }
    
    func states(populationGreaterThan min: Int) -> [State]
    {
        var largerPopStates = [State]()
        for state in states
        {
            if state.population > min
            {
                largerPopStates.append(state)
            }
            else
            {
                break
            }
        }
        return largerPopStates
    }
}
