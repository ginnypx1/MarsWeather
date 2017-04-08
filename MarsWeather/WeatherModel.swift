//
//  WeatherModel.swift
//  MarsWeather
//
//  Created by Ginny Pennekamp on 3/23/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation
import UIKit

enum WeatherType: String {
    case sunny
    case cloudy
    case rainy
}

struct EarthWeather {
    var date: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    var temperature: String?
    var maxTemperature: String?
    var minTemperature: String?
    var humidity: String?
    var windSpeed: String?
    var weatherIcon: UIImage?
    
    // construct a local weather report from a dictionary
    init(currentDictionary: [String:AnyObject], dailyDictionary: [String:AnyObject]) {
        print("making earth weather report")
        if let temp = currentDictionary[DarkSkyRequest.DarkSkyResponseKeys.currentTemperature] as? Double {
            let roundedTemp = Int(round(temp))
            temperature = "\(roundedTemp)º"
        }
        if let maxTemp = dailyDictionary[DarkSkyRequest.DarkSkyResponseKeys.maxTemperature] as? Double, let minTemp = dailyDictionary[DarkSkyRequest.DarkSkyResponseKeys.minTemperature] as? Double {
            let minTempOneDecimal = String(format: "%.1f", minTemp)
            let maxTempOneDecimal = String(format: "%.1f", maxTemp)
            minTemperature = "\(minTempOneDecimal)ºF"
            maxTemperature = "\(maxTempOneDecimal)ºF"
        } else {
            minTemperature = "0ºF"
            maxTemperature = "0ºF"
        }
        if let humidValue = currentDictionary[DarkSkyRequest.DarkSkyResponseKeys.humidity] as? Double {
            humidity = "\(humidValue * 100)%"
        } else {
            humidity = "0.0%"
        }
        if let earthWindSpeed = currentDictionary[DarkSkyRequest.DarkSkyResponseKeys.windSpeed] as? Double {
            windSpeed = "\(earthWindSpeed)"
        } else {
            windSpeed = "0.0"
        }
        if let currentWeatherString = currentDictionary[DarkSkyRequest.DarkSkyResponseKeys.currentWeather] as? String {
            if currentWeatherString.lowercased() == WeatherType.sunny.rawValue {
                weatherIcon = UIImage(named: WeatherType.sunny.rawValue)
            } else if currentWeatherString.lowercased().contains("cloud") {
                weatherIcon = UIImage(named: WeatherType.cloudy.rawValue)
            } else if currentWeatherString.lowercased().contains("rain") {
                weatherIcon = UIImage(named: WeatherType.rainy.rawValue)
            }
        } else {
            weatherIcon = UIImage(named: WeatherType.sunny.rawValue)
        }
        print("finished earth weather report")
    }
}

struct MarsWeather {
    var date: String?
    var location: String = "Curiosity Rover, Mars"
    var temperature: String?
    var maxTemperature: String?
    var minTemperature: String?
    var pressure: String?
    var windSpeed: String?
    var weatherIcon: UIImage?
    
    // construct a martian weather report from a dictionary
    init(dictionary: [String:AnyObject]) {
        if let marsDate = dictionary[MarsRequest.MarsResponseKeys.marsDate] as? Int {
            date = "Sol \(marsDate)"
        } else {
            date = "Sol"
        }
        if let maxTemp = dictionary[MarsRequest.MarsResponseKeys.maxTemperature] as? Double, let minTemp = dictionary[MarsRequest.MarsResponseKeys.minTemperature] as? Double {
            let averageTemp = Int(round((minTemp+maxTemp)/2))
            temperature = "\(averageTemp)º"
            minTemperature = "\(minTemp)ºF"
            maxTemperature = "\(maxTemp)ºF"
        } else {
            temperature = "0ºF"
            minTemperature = "0ºF"
            maxTemperature = "0ºF"
        }
        if let marsPressure = dictionary[MarsRequest.MarsResponseKeys.pressure] as? Int {
            pressure = "\(marsPressure)"
        } else {
            pressure = ""
        }
        if let marsWindSpeed = dictionary[MarsRequest.MarsResponseKeys.windSpeed] as? Double {
            windSpeed = "\(marsWindSpeed)"
        } else {
            windSpeed = "0.0"
        }
        if let currentWeatherString = dictionary[MarsRequest.MarsResponseKeys.currentWeather] as? String {
            if currentWeatherString.lowercased() == WeatherType.sunny.rawValue {
                weatherIcon = UIImage(named: WeatherType.sunny.rawValue)
            } else {
                weatherIcon = UIImage(named: WeatherType.cloudy.rawValue)
            }
        } else {
            weatherIcon = UIImage(named: WeatherType.rainy.rawValue)
        }
    }
}
