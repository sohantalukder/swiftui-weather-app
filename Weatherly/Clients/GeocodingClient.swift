//
//  GeocodingClient.swift
//  Weatherly
//
//  Created by Md Sohan Talukder on 12/11/24.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
}

struct GeocodingClient {
    
    func coordinateByCity(_ city: String) async throws -> Location? {
        let (data, response) = try await URLSession.shared.data(from: APIEndPoint.endPointURL(for: .coordinatesByLocationName(city)))
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let locations = try JSONDecoder().decode([Location].self, from: data)
        return locations.first
        
    }
}
