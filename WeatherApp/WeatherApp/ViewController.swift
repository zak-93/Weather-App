//
//  ViewController.swift
//  WeatherApp
//
//  Created by Yashin Zahar on 08.08.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    let locationManadger = CLLocationManager()
    let gradientLayer = CAGradientLayer()
    var lat: Double?
    var lon: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(viewKeyboard))
        view.addGestureRecognizer(recognizer)
        locationManadger.delegate = self
        locationManadger.desiredAccuracy = kCLLocationAccuracyBest
        locationManadger.requestAlwaysAuthorization()
        locationManadger.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
    }
    
    @IBAction func viewKeyboard() {
        self.view.endEditing(true)
    }
    
    func setBlueGradientBackground() {
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setGrayGradientBackground() {
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocationCoordinate2D = manager.location!.coordinate
        self.lat = location.latitude
        self.lon = location.longitude
    }
    
    func geolocationTemp() {
        NetworkManager.shared.geolocationWeather(lat: lat!, lon: lon!, result: { (model) in
            DispatchQueue.main.async {
                let modelIcon = model?.weather.first?.icon
                let modelTemp = Int((model?.main?.temp)!)
                let modelWind = Int((model?.wind?.speed)!)
                let modelHumidity = Int((model?.main?.humidity)!)
                let weather = model?.weather.first?.description
                self.weatherLabel.text = weather
                self.tempLabel.text = " \(modelTemp) \u{2103}"
                self.cityNameLabel.text = "\(model!.name!)"
                self.speedLabel.text = "Wing".localization() + " \(modelWind) m/s"
                self.humidityLabel.text = "Humidity".localization() + " \(modelHumidity) %"
                self.iconImage.image = UIImage(named: modelIcon!)
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayOfTheWeekLabel.text = dateFormatter.string(from: date)
                
                let suffix = modelIcon?.suffix(1)
                if (suffix == "n") {
                    self.setGrayGradientBackground()
                } else {
                    self.setBlueGradientBackground()
                }
            }
        })
        
    }
    
    func cityTemp() {
        let city = self.cityTextField.text
        if city == "" {
            alert()
        } else {
            NetworkManager.shared.hetWeather(city: city!) { (model) in
                DispatchQueue.main.async {
                    let modelIcon = model?.weather.first?.icon
                    let modelTemp = Int((model?.main?.temp)!)
                    let modelWind = Int((model?.wind?.speed)!)
                    let modelHumidity = Int((model?.main?.humidity)!)
                    let weather = model?.weather.first?.description
                    self.weatherLabel.text = weather
                    self.tempLabel.text = " \(modelTemp) \u{2103}"
                    self.cityNameLabel.text = "\(model!.name!)"
                    self.speedLabel.text = "Wing".localization() + " \(modelWind) m/s"
                    self.humidityLabel.text = "Humidity".localization() + " \(modelHumidity) %"
                    self.iconImage.image = UIImage(named: modelIcon!)
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE"
                    self.dayOfTheWeekLabel.text = dateFormatter.string(from: date)
                    
                    let suffix = modelIcon?.suffix(1)
                    if (suffix == "n") {
                        self.setGrayGradientBackground()
                    } else {
                        self.setBlueGradientBackground()
                    }
                }
            }
        }
    }
    
    func alert() {
        let alert = UIAlertController(title: "City name not entered", message: "Enter city name", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    
    @IBAction func searchCityButton(_ sender: UIButton) {
        cityTemp()
    }
    @IBAction func gpsLocation(_ sender: UIButton) {
        geolocationTemp()
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}


