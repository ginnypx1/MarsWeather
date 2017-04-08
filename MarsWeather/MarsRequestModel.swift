//
//  MarsRequestModel.swift
//  MarsWeather
//
//  Created by Ginny Pennekamp on 3/23/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
// 

import Foundation

struct MarsRequest {
    
    // MARK: - Properties
    
    struct MarsURL {
        static let Scheme: String = "http"
        static let Host: String = "marsweather.ingenology.com"
        static let Path: String = "/v1/latest/"
    }
    
    struct MarsParameterKeys {
        static let APIKey: String = "api_key"
        static let Format: String = "format"
    }
    
    struct MarsParameterValues {
        static let APIKey: String = MARS_API_KEY
        static let JSON: String = "json"
    }
    
    struct MarsResponseKeys {
        static let report: String = "report"
        static let earthDate: String = "terrestrial_date"
        static let marsDate: String = "sol"
        static let minTemperature: String = "min_temp_fahrenheit"
        static let maxTemperature: String = "max_temp_fahrenheit"
        static let pressure: String = "pressure"
        static let windSpeed: String = "wind_speed"
        static let currentWeather: String = "atmo_opacity"
    }
    
    func buildURL() -> URL {
        var components = URLComponents()
        components.scheme = MarsURL.Scheme
        components.host = MarsURL.Host
        components.path = MarsURL.Path
        components.queryItems = [URLQueryItem(name: MarsParameterKeys.APIKey, value: MarsParameterValues.APIKey),
                                 URLQueryItem(name: MarsParameterKeys.Format, value: MarsParameterValues.JSON)]
        //print("MarsRequestURL is: \(components.url!)")
        return components.url!
    }
}
