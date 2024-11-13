//
//  ApiEndPoint.swift
//  Weatherly
//
//  Created by Md Sohan Talukder on 12/11/24.
//

import Foundation

enum APIEndPoint {
    static let baseUrl = "https://api.openweathermap.org"
    
    case coordinatesByLocationName(String)
    case weatherByLatLon(Double, Double)
    
    private var path: String {
        switch self {
            case .coordinatesByLocationName(let city):
            return "/geo/1.0/direct?q=\(city)&appid=\(Constants.keys.apiKey)"
            case .weatherByLatLon(let lat, let lon):
            return "/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.keys.apiKey)"
        }
    }
    
    static func endPointURL(for endPoint: APIEndPoint) -> URL {
        let endpointPath = endPoint.path
        return URL(string: baseUrl + endpointPath)!
    }
}
