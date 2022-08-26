//
//  ModelApp.swift
//  WeatherApp
//
//  Created by Yashin Zahar on 08.08.2022.
//

import Foundation

class ModalApp: Codable {
    var coord: Coord?
    var weather: [Weather]
    var main: MainModel?
    var wind: WindModel?
    var name: String?
}
