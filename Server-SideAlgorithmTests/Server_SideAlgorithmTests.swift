//
//  Server_SideAlgorithmTests.swift
//  Server-SideAlgorithmTests
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import XCTest
@testable import Server_SideAlgorithm

class Server_SideAlgorithmTests: XCTestCase
{
    var states: [State]!
    var zipCodeCalculator: ZipCodeCalculator!
    
    override func setUp()
    {
        super.setUp()
        states = State.loadTestData()
        if let states = states
        {
            zipCodeCalculator = ZipCodeCalculator(states: states)
        }
        
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testZipCodeLoadingFromServer()
    {
        let serverExpectation = expectation(description: "Loading from server.")
        ZipCodeClient.fetchJSONData
        { (result) in
            switch result
            {
            case .error(let error):
                XCTFail("Response was error: \(error.localizedDescription)")
            case .success:
                serverExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 60.0)
        { (error) in
            if let error = error
            {
                print(error.localizedDescription)
            }
        }
    }
    
    func testZipCodeParsing()
    {
        XCTAssertNotNil(states, "states must be non nil.")
        XCTAssertEqual(states.flatMap { $0.cities }.flatMap { $0.zipCodes }.count,
                       29_353,
                       "states must have 29,353 zip codes.")
        XCTAssertEqual(states.count,
                       51,
                       "states must have 51 elements.")
    }
    
    func testStateNotFound()
    {
        XCTAssertThrowsError(try zipCodeCalculator.state(for: "BX"))
    }
    
    func testInvalidParametersNumbers()
    {
        XCTAssertThrowsError(try zipCodeCalculator.state(for: "B1"))
    }
    
    func testInvalidParametersTooMantLetters()
    {
        XCTAssertThrowsError(try zipCodeCalculator.state(for: "MASS"))
    }
    
    func testStatePopulation()
    {
        XCTAssertNoThrow(try zipCodeCalculator.state(for: "DC"))
        let state = try! zipCodeCalculator.state(for: "DC")
        XCTAssertEqual(state.population,
                       606_900,
                       "DC must have 606,900 as total population")
    }
    
    func testMoreThanTenMillion()
    {
        XCTAssertEqual(zipCodeCalculator.states(populationGreaterThan: 10_000_000).count,
                       7,
                       "There must be 7 states greater than 10,000,000")
        XCTAssertEqual(zipCodeCalculator.states(populationGreaterThan: 10_000_000).first!.abbreviation,
                       "CA",
                       "The largest state greater than 10,000,000 must be abbreviated CA")
    }
    
    func testAveragePopulation()
    {
        XCTAssertEqual(try! zipCodeCalculator.state(for: "DC").avarageCityPopulation,
                       303_450,
                       "DC must have 303,450 as average city population")
    }
    
    func testAveragePopulationResponse()
    {
        XCTAssertEqual(try! zipCodeCalculator.averagePopulationResponse(forState: "DC")!,
                       "{\n  \"avgCityPop\" : 303450,\n  \"_id\" : \"DC\"\n}",
                       "Must have correct json response")
    }
    
    func testSmallestLargestCity()
    {
        XCTAssertEqual(try! zipCodeCalculator.state(for: "DC").smallestPopulationCity!.name,
                       "PENTAGON",
                       "DC's smallest city must be named PENTAGON")
        XCTAssertEqual(try! zipCodeCalculator.state(for: "DC").largestPopulationCity!.name,
                       "WASHINGTON",
                       "DC's largest city must be named WASHINGTON")
    }
}
