//
//  DarkSkyRequestModel.swift
//  MarsWeather
//
//  Created by Ginny Pennekamp on 3/24/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import Foundation

struct DarkSkyRequest {
    
    // MARK: - Properties
    
    struct DarkSkyURL {
        static let Scheme: String = "https"
        static let Host: String = "api.darksky.net"
        static let Path: String = "/forecast/\(DARK_SKY_API_KEY)/"
    }
    
    struct DarkSkyParameterKeys {
        static let Exclude = "exclude"
    }
    
    struct DarkSkyParameterValues {
        static let Exclusions: String = "[\"minutely\",\"hourly\",\"alerts\",\"flags\"]"
    }
    
    struct DarkSkyResponseKeys {
        static let currentlyReport: String = "currently" // current temp, humidity, windSpeed icon
        static let dailyReport: String = "daily" // next level is data
        static let data: String = "data" // max temp, min temp
        static let currentTemperature: String = "temperature"
        static let minTemperature: String = "temperatureMin"
        static let maxTemperature: String = "temperatureMax"
        static let humidity: String = "humidity"
        static let windSpeed: String = "windSpeed"
        static let currentWeather: String = "icon"
    }
    
    func buildURL(latitude: Double, longitude: Double) -> URL {
        var components = URLComponents()
        components.scheme = DarkSkyURL.Scheme
        components.host = DarkSkyURL.Host
        components.path = DarkSkyURL.Path + "\(latitude),\(longitude)"
        components.queryItems = [URLQueryItem(name: DarkSkyParameterKeys.Exclude, value:DarkSkyParameterValues.Exclusions)]
        //print("DarkSkyReqeustURL is: \(components.url!)")
        return components.url!
    }
}
