//
//  MeasurementFormatter+Extensions.swift
//  Weatherly
//
//  Created by Md Sohan Talukder on 13/11/24.
//

import Foundation

extension MeasurementFormatter {
    static func temparature(value: Double) -> String {
        let numberForammter = NumberFormatter()
        numberForammter.minimumFractionDigits = 0
        
        let formatter = MeasurementFormatter()
        formatter.numberFormatter = numberForammter
        
        let temp = Measurement(value: value, unit: UnitTemperature.kelvin)
        
        return formatter.string(from: temp)
        
    }
}
