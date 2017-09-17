//
//  Prompt.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/17/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

struct Prompt
{
    var command: String?
    let timestamp: Date
}

extension Prompt
{
    init(command: String? = nil, date: Date = Date())
    {
        self.command = command
        self.timestamp = date
    }
}
