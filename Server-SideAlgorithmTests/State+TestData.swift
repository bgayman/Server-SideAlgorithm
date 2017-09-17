//
//  State+TestData.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

extension State
{
    static func loadTestData() -> [State]?
    {
        let bundle = Bundle(for: Server_SideAlgorithmTests.self)
        guard let url = bundle.url(forResource: "testData", withExtension: "json") else { return nil }
        
        return ZipCodeClient.parseZipCodeJSON(fileURL: url)
    }
}
