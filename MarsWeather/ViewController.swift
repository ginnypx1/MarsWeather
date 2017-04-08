//
//  ViewController.swift
//  MarsWeather
//
//  Created by Ginny Pennekamp on 3/23/17.
//  Copyright © 2017 GhostBirdGames. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    
    // outlets for Earth weather
    @IBOutlet weak var earthDateLabel: UILabel!
    @IBOutlet weak var earthLocationLabel: UILabel!
    @IBOutlet weak var earthTemperatureLabel: UILabel!
    @IBOutlet weak var earthMaxTemperatureLabel: UILabel!
    @IBOutlet weak var earthMinTemperatureLabel: UILabel!
    @IBOutlet weak var earthHumidityLabel: UILabel!
    @IBOutlet weak var earthWindSpeedLabel: UILabel!
    @IBOutlet weak var earthWeatherIcon: UIImageView!
    
    // outlets for Mars weather
    @IBOutlet weak var marsDateLabel: UILabel!
    @IBOutlet weak var marsLocationLabel: UILabel!
    @IBOutlet weak var marsTemperatureLabel: UILabel!
    @IBOutlet weak var marsMaxTemperatureLabel: UILabel!
    @IBOutlet weak var marsMinTemperatureLabel: UILabel!
    @IBOutlet weak var marsPressureLabel: UILabel!
    @IBOutlet weak var marsWindSpeedLabel: UILabel!
    @IBOutlet weak var marsWeatherIcon: UIImageView!
    
    // MARK: - Properties
    
    var client = Client()
    
    var activityIndicator: UIActivityIndicatorView!
    
    var userLocation: CLLocation?
    var locationAuthorizationStatus: CLAuthorizationStatus!
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var seenError: Bool = false
    var locationFixAchieved: Bool = false
    var locationStatus: NSString = "Not Started"
    
    var latitude: Double = 34.0522
    var longitude: Double = 118.2437
    var location: String = "Los Angeles, CA"
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add activity indicator
        addActivityIndicator()
        // location manager set up
        initLocationManager()
        // get the user's location
        locationManager.requestLocation()
    }

    // MARK: - Location Manager Delegate
    
    func initLocationManager() {
        // set up location manager
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        if (seenError == false) {
            seenError = true
            print(error)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LabelHasbeenUpdated"), object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
    
    // MARK: - Get User Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        manager.stopUpdatingLocation()
        self.activityIndicator.startAnimating()
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            self.userLocation = locationObj
            self.latitude = coord.latitude
            self.longitude = coord.longitude
            
            // display labels
            getLocationName() { (success: Bool) -> Void in
                if success {
                    self.loadMarsWeather()
                    self.loadEarthWeather()
                } else {
                    DispatchQueue.main.async {
                        Alerts.displayStandardAlert(from: self)
                    }
                }
            }
        }
    }
    
    // MARK: - Retrieve Location Name
    
    func getLocationName(completionHandler: @escaping (_ success: Bool) -> Void) {
        
        // get nearest address
        guard let addressLocation: CLLocation = self.userLocation else {
            print("The user has no current location stored")
            return
        }
        
        CLGeocoder().reverseGeocodeLocation(addressLocation, completionHandler: {(placemarks, error) -> Void in
            print(addressLocation)
            
            if error != nil {
                print("Reverse geocoder failed with error \(error!.localizedDescription)")
                DispatchQueue.main.async {
                    Alerts.displayLocationAlert(from: self)
                }
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                if let city = pm.addressDictionary!["City"] as? String,
                   let state = pm.addressDictionary!["State"] as? String {
                    self.location = "\(city), \(state)"
                }
                completionHandler(true)
                
            } else {
                print("Problem with the data received from geocoder")
                completionHandler(false)
            }
        })
    }
    
    // MARK: - GET request
    
    func loadMarsWeather() {
        // calls taskForGETMethod to retrieve data, completion handler tells data to save as marsWeather object
        
        let MarsURL = MarsRequest().buildURL()
        
        client.taskForGETMethod(request: MarsURL, completionHandlerForGET: { (result: AnyObject?, error:NSError?) -> Void in
            
            if error != nil {

                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if isInternetAvailable() == false {
                        // Alert no internet
                        Alerts.displayInternetConnectionAlert(from: self)
                    } else {
                        // Alert login failure
                        Alerts.displayStandardAlert(from: self)
                    }
                }
                
            } else {
                /* GUARD: Are the correct keys in our result? */
                guard let martianWeatherReport = result?[MarsRequest.MarsResponseKeys.report] as? [String: AnyObject] else {
                    print("No weather report was found in the result")
                    return
                }
                
                // save as martian weather report
                let marsWeather = MarsWeather(dictionary: martianWeatherReport)
                
                // update the UI
                DispatchQueue.main.async {
                    self.marsDateLabel.text = marsWeather.date
                    self.marsLocationLabel.text = marsWeather.location
                    self.marsTemperatureLabel.text = marsWeather.temperature
                    self.marsMaxTemperatureLabel.text = marsWeather.maxTemperature
                    self.marsMinTemperatureLabel.text = marsWeather.minTemperature
                    self.marsPressureLabel.text = marsWeather.pressure
                    self.marsWindSpeedLabel.text = marsWeather.windSpeed
                    self.marsWeatherIcon.image = marsWeather.weatherIcon
                }
            }
        })
    }
    
    func loadEarthWeather() {
        // calls taskForGETMethod to retrieve data, completion handler tells data to save as earthWeather object
        
        let EarthURL = DarkSkyRequest().buildURL(latitude: self.latitude, longitude: self.longitude)
        
        client.taskForGETMethod(request: EarthURL, completionHandlerForGET: { (result: AnyObject?, error:NSError?) -> Void in
            
            if error != nil {
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if isInternetAvailable() == false {
                        // Alert no internet
                        Alerts.displayInternetConnectionAlert(from: self)
                    } else {
                        // Alert login failure
                        Alerts.displayStandardAlert(from: self)
                    }
                }
                
            } else {

                /* GUARD: Are the correct keys in our result? */
                guard let currentlyWeatherReport = result?[DarkSkyRequest.DarkSkyResponseKeys.currentlyReport] as? [String: AnyObject],
                let dailyWeatherReport = result?[DarkSkyRequest.DarkSkyResponseKeys.dailyReport] as? [String: AnyObject] else {
                    print("The correct weather reports were not found in the result")
                    return
                }
                
                // access daily data
                guard let dailyData = dailyWeatherReport[DarkSkyRequest.DarkSkyResponseKeys.data] as? [AnyObject], let dailyWeather = dailyData[0] as? [String:AnyObject] else {
                    print("There was an error accessing the daily weather report")
                    return
                }
                
                // save as earth weather report
                let earthWeather = EarthWeather(currentDictionary: currentlyWeatherReport, dailyDictionary: dailyWeather)
                
                // update the UI
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    
                    self.earthDateLabel.text = earthWeather.date
                    self.earthLocationLabel.text = self.location
                    self.earthTemperatureLabel.text = earthWeather.temperature
                    self.earthMaxTemperatureLabel.text = earthWeather.maxTemperature
                    self.earthMinTemperatureLabel.text = earthWeather.minTemperature
                    self.earthHumidityLabel.text = earthWeather.humidity
                    self.earthWindSpeedLabel.text = earthWeather.windSpeed
                    self.earthWeatherIcon.image = earthWeather.weatherIcon
                }
            } 
        })
    }

    @IBAction func linkToDarkSky(_ sender: Any) {
        /*You are required to display the message “Powered by Dark Sky” (linking to https://darksky.net/poweredby/) somewhere prominent in your app or service. (Details can be found in the terms themselves).*/
        if let url = NSURL(string: "https://darksky.net/poweredby/"){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }

}

