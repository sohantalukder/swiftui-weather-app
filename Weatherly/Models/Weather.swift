//
//  Weather.swift
//  Weatherly
//
//  Created by Md Sohan Talukder on 12/11/24.
//

import Foundation

struct WatherResponse: Decodable {
    let main: Weather
}

struct Weather: Decodable {
    let temp: Double
}
