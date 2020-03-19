//
//  Weather.swift
//  Weather3Days4ecast
//
//  Created by RA on 18/03/2020.
//  Copyright © 2020 RA. All rights reserved.
//

import Foundation

class Weather {
    var city = City()
    
    // Section Main
    var temperature : Float = 0
    var feelsLike : Float = 0
    var temperatureMax : Float = 0
    var temperatureMin : Float = 0
    var pressure : Int = 0
    var pressureSeaLevel : Int = 0
    var pressureGrndLevel : Int = 0
    var humidity : Int = 0
    
    
    // Section Weather
    var conditionID : Int = 0
    var conditionMain : String = ""
    var conditionDescription : String = ""
    var conditionIcon : String = ""
    
    // section Wind
    var windSpeed : Float = 0
    var windDeg : Float = 0
    var windDirection : String = ""
    
    // Section Rain
    var rain1h : Int = 0
    var rain3h : Int = 0
    
    // Section Snow
    var snow1h : Int = 0
    var snow3h : Int = 0
    
    // section Sys included in City model 

    
    // Section Other, exclude "coord", "name" and some internal parameters
    var base : String = ""
    var clouds : Int = 100
    var dateTime : Int = 0
    var dateTimeText : String = ""
    var localDateTime : Int!
    
  
    
    func getTime(timeZone: TimeZone, interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    func setWindDirection(degree : Float) -> String {
        let directions = ["Nord", "Nord-East", "East", "South-East", "South", "South-West", "West", "Nord-West"]
        let i: Int = Int((degree + 33.75)/45)
        return directions[i % 8]
    }
    
    func getDate(timeZone: TimeZone, interval: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
