//
//  Reader.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

/// Small class for reading in file up a set deliminator at a time

class Reader
{
    // MARK: - Properties
    let encoding: String.Encoding
    let readSize: Int
    var fileHandle: FileHandle!
    let deliminatorData: Data
    var buffer: Data
    var isAtEnd: Bool
    
    // MARK: - Lifecycle
    init?(url: URL, delimiter: String = "\n", encoding: String.Encoding = .utf8, readSize: Int = 4096)
    {
        guard let fileHandle = try? FileHandle(forReadingFrom: url),
              let deliminatorData = delimiter.data(using: encoding)
        else { return nil }
        
        self.encoding = encoding
        self.readSize = readSize
        self.fileHandle = fileHandle
        self.deliminatorData = deliminatorData
        self.buffer = Data(capacity: readSize)
        self.isAtEnd = false
    }
    
    deinit
    {
        self.close()
    }
    
    func close()
    {
        fileHandle?.closeFile()
        fileHandle = nil
    }
    
    /// Returns next line of file or nil if at end
    func nextLine() -> String?
    {
        guard fileHandle != nil else { return nil }
        
        while !isAtEnd
        {
            if let range = buffer.range(of: deliminatorData)
            {
                let line = String(data: buffer.subdata(in: 0 ..< range.lowerBound), encoding: encoding)
                buffer.removeSubrange(0 ..< range.upperBound)
                return line
            }
            let tempData = fileHandle.readData(ofLength: readSize)
            if tempData.count > 0
            {
                buffer.append(tempData)
            }
            else
            {
                isAtEnd = true
                if buffer.count > 0
                {
                    // Buffer contains last line of file not terminated by deliminator
                    let line = String(data: buffer, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }
}

extension Reader: Sequence
{
    func makeIterator() -> AnyIterator<String>
    {
        return AnyIterator
        {
            return self.nextLine()
        }
    }
}
