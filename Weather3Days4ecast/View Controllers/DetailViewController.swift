//
//  ViewController.swift
//  Weather3Days4ecast
//
//  Created by RA on 17/03/2020.
//  Copyright © 2020 RA. All rights reserved.
//

import UIKit
import Weathersama
import LatLongToTimezone
import CoreLocation
import SwiftVideoBackground


class DetailViewController: UIViewController {

    var selectedCity : WeatherModel!
    var selectedCityTimezone : Int = 0
    
    @IBOutlet var backGroundImage: UIImageView!
    
    @IBOutlet var selectedCityLabel: UILabel!
    
    @IBOutlet var weatherIcon: UIImageView!
    
    @IBOutlet var mainTempLabel: UILabel!
    
    @IBOutlet var mainFeelsTempLabel: UILabel!
    
    @IBOutlet var mainTempMax: UILabel!
    
    @IBOutlet var mainTempMin: UILabel!
    
    @IBOutlet var weatherMainLabel: UILabel!
    
    @IBOutlet var weatherDesriptionLabel: UILabel!
    
    @IBOutlet var mainPressureLabel: UILabel!
    
    @IBOutlet var mainHumidityLabel: UILabel!
    
    @IBOutlet var visibilityLabel: UILabel!
    
    @IBOutlet var windSpeedLabel: UILabel!
    
    @IBOutlet var windDegLabel: UILabel!
    
    @IBOutlet var sunriseLabel: UILabel!
    
    @IBOutlet var sunsetLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    override func viewDidAppear(_ animated: Bool) {
        
        let location = CLLocationCoordinate2D(latitude: selectedCity.coordinate.latitude, longitude: selectedCity.coordinate.longitude)
        let timeZone = TimezoneMapper.latLngToTimezone(location)
        
        let fileName = getWeatherCondition(weather: selectedCity.weather[0].main, hour: Int(getHourByInterval(timeZone: timeZone! , timeInterval: selectedCity.dt))!)
        
        try? VideoBackground.shared.play(view: view, videoName: fileName, videoType: "mp4")
        
        self.backGroundImage.removeFromSuperview()
        
        selectedCityLabel.text = selectedCity.cityName
        
        getImageFromWeb(ICON_URL + selectedCity.weather[0].icon + ICON_FILE_EXT) { (image) in
            if let image = image {
                self.weatherIcon.image = image
            } // if you use an Else statement, it will be in background
        }
      
        mainTempLabel.text = (selectedCity.main.temperature != nil) ? "\(Float(selectedCity.main.temperature)) ºC" : "---"

        mainFeelsTempLabel.text = (selectedCity.main.temperature != nil) ? "\(Float(selectedCity.main.temperature)) ºC" : "---"

        mainTempMax.text = (selectedCity.main.temperatureMax != nil) ? "\(Float(selectedCity.main.temperatureMax)) ºC" : "---"

        mainTempMin.text = (selectedCity.main.temperatureMin != nil) ? "\(Float(selectedCity.main.temperatureMin)) ºC" : "---"

        weatherMainLabel.text = selectedCity.weather[0].main

        weatherDesriptionLabel.text = selectedCity.weather[0].description

        mainPressureLabel.text = (selectedCity.main.pressure != nil) ? "\(Int(selectedCity.main.pressure)) kPa" : "---"

        mainHumidityLabel.text = (selectedCity.main.humidity != nil) ? "\(Int(selectedCity.main.humidity)) %" : "---"
        
        // TODO use this option when a parsed forecst
        // visibilityLabel.text = "\(Int(selectedCity.visibility)) m"

        windSpeedLabel.text = (selectedCity.wind.speed != nil) ? "\(Float(selectedCity.wind.speed)) m/c" : "---"
        
        windDegLabel.text = (selectedCity.wind.deg != nil) ? "\(setWindDirection(degree: Float(selectedCity.wind.deg))) \( (Int(selectedCity.wind.deg)))º" : "---"
       
        sunriseLabel.text = getTimeByInterval(timeZone: timeZone! , interval: selectedCity.sys.sunrise)

        sunsetLabel.text = getTimeByInterval(timeZone: timeZone!, interval: selectedCity.sys.sunset)
        
        
    }
    
}

