//
//  Untitled.swift
//  Weatherly
//
//  Created by Md Sohan Talukder on 12/11/24.
//

import Foundation

struct WeatherClient {
    func fetchWeather(location: Location) async throws -> Weather {
        let (data, response) = try await URLSession.shared.data(from: APIEndPoint.endPointURL(for: .weatherByLatLon(location.lat, location.lon)))
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
        }
        
        let weatherResponse = try JSONDecoder().decode(WatherResponse.self, from: data)
        return weatherResponse.main
    }
}
