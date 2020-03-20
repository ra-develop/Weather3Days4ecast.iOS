//
//  ViewController.swift
//  Weather3Days4ecast
//
//  Created by RA on 17/03/2020.
//  Copyright © 2020 RA. All rights reserved.
//

import UIKit
import Weathersama


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
        
        selectedCityLabel.text = selectedCity.cityName

        
        let initialBackGroundImagePosition = self.backGroundImage.frame.origin.x

        // Control of background image animation of main screen
        UIView.animate(withDuration: 60.0, delay: 1.0, options: [.curveEaseOut, .curveEaseIn, .autoreverse] , animations: {
            var backGroundImageFrame = self.backGroundImage.frame
            backGroundImageFrame.origin.x += backGroundImageFrame.size.width - self.view.bounds.width
            self.backGroundImage.frame = backGroundImageFrame
            }, completion: { finished in self.backGroundImage.frame.origin.x = initialBackGroundImagePosition })
        
        getImageFromWeb(ICON_URL + selectedCity.weather[0].icon + ICON_FILE_EXT) { (image) in
            if let image = image {
                self.weatherIcon.image = image
            } // if you use an Else statement, it will be in background
        }
      
        mainTempLabel.text = "\(Float(selectedCity.main.temperature)) ºC"

        mainFeelsTempLabel.text = "\(Float(selectedCity.main.temperature)) ºC"

        mainTempMax.text = "\(Float(selectedCity.main.temperatureMax)) ºC"

        mainTempMin.text = "\(Float(selectedCity.main.temperatureMin)) ºC"

        weatherMainLabel.text = selectedCity.weather[0].main

        weatherDesriptionLabel.text = selectedCity.weather[0].description

        mainPressureLabel.text = "\(Int(selectedCity.main.pressure)) kPa"

        mainHumidityLabel.text = "\(Int(selectedCity.main.humidity)) %"

//        visibilityLabel.text = "\(Int(selectedCity.visibility)) m"

        windSpeedLabel.text = "\(Float(selectedCity.wind.speed)) m/c"

        windDegLabel.text = "\(Int(selectedCity.wind.speed)) Deg"

        sunriseLabel.text = getTimeByInterval(timeZone: TimeZone.init(secondsFromGMT: selectedCityTimezone)! , interval: selectedCity.sys.sunrise)

        sunsetLabel.text = getTimeByInterval(timeZone: TimeZone.init(secondsFromGMT: selectedCityTimezone)!, interval: selectedCity.sys.sunset)
        
        
    }
    
}

