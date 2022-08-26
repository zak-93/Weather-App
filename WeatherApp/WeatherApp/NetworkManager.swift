//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Yashin Zahar on 08.08.2022.
//

import Foundation

class NetworkManager {
    private init() {}
    
    static let shared = NetworkManager()
    
    func geolocationWeather(lat: Double, lon: Double, result: @escaping((ModalApp?) -> ())) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=35af60600d37343e1036490eec5c270f&units=metric" ) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    let decoder = JSONDecoder()
                    var decoderModelApp: ModalApp?
                    decoderModelApp = try decoder.decode(ModalApp.self, from: data)
                    result(decoderModelApp)
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    func hetWeather(city: String, result: @escaping((ModalApp?)-> ())) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=35af60600d37343e1036490eec5c270f&units=metric" ) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil, let data = data {
                do {
                    let decoder = JSONDecoder()
                    var decoderModelApp: ModalApp?
                    decoderModelApp = try decoder.decode(ModalApp.self, from: data)
                    result(decoderModelApp)
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    
}

extension String {
    func localization() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
