//
//  ZipCodeClient.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/16/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

enum Result<T>
{
    case error(error: Error)
    case success(response: T)
}

struct ZipCodeClient
{
    typealias ZipCodeFetchCompletion = (Result<[State]>) -> Void
    
    private static let jsonURL = URL(string: "https://media.mongodb.org/zips.json")!
    
    static func fetchJSONData(completion: @escaping ZipCodeFetchCompletion)
    {
        URLSession.shared.downloadTask(with: jsonURL)
        { (fileURL, _, error) in
            guard error == nil else
            {
                DispatchQueue.main.async
                {
                    completion(.error(error: error!))
                }
                return
            }
            
            if let fileURL = fileURL,
               let states = parseZipCodeJSON(fileURL: fileURL)
            {
                DispatchQueue.main.async
                {
                    completion(.success(response: states))
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    let parseError = NSError(domain: "com.bradgayman.Server-SideAlgorithm", code: 1, userInfo: ["NSDebugDescription": "Failed to parse", "NSLocalizedDescription": "Could not read zip code data."])
                    completion(.error(error: parseError))
                }
            }
        }.resume()
    }
    
    static func parseZipCodeJSON(fileURL: URL) -> [State]?
    {
        guard let reader = Reader(url: fileURL) else { return nil }
        
        var states = [String: [ZipCode]]()
        while let jsonDictString = reader.nextLine()
        {
            if let jsonData = jsonDictString.data(using: .utf8),
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: []),
                let jsonDictionary = json as? JSONDictionary,
                let zipCode = ZipCode(dictionary: jsonDictionary)
            {
                if var zipCodesForState = states[zipCode.state]
                {
                    zipCodesForState.append(zipCode)
                    states[zipCode.state] = zipCodesForState
                }
                else
                {
                    states[zipCode.state] = [zipCode]
                }
            }
        }
        return states.map(State.init)
    }
}
