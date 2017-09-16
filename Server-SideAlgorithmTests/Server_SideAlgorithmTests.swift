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
    let zipCodes: [ZipCode]!
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
        let zipCodes = ZipCode.loadTestData()

    }
    
    func testZipCodeLoading()
    {
        XCTAssertNotNil(zipCodes, "zipCodes must be non nil.")
        XCTAssertEqual(zipCodes.count, 29353, "zipCodes must have 29353 documents.")
    }
    
}
