//
//  Service.swift
//  Weather3Days4ecast
//
//  Created by RA on 20/03/2020.
//  Copyright © 2020 RA. All rights reserved.
//

import Foundation
import UIKit

// Geting of current date
func getCurentDateWithWeekDay () -> String {
    let date = Calendar.current.date(byAdding: .day, value: 0, to: Date())
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
    
    return dateFormatter.string(from: date!)
}

func getCurentDateStandart () -> String {
    let date = Calendar.current.date(byAdding: .day, value: 0, to: Date())
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter.string(from: date!)
}



//Gering Image file from Web
    func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            return closure(nil)
        }
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return closure(nil)
            }
            guard response != nil else {
                print("no response")
                return closure(nil)
            }
            guard data != nil else {
                print("no data")
                return closure(nil)
            }
            DispatchQueue.main.async {
                closure(UIImage(data: data!))
            }
        }; task.resume()
    }

//import SwiftUI //not usabile by require of Project
//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}


func getTimeByInterval(timeZone: TimeZone, interval: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(interval))
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}

func getHourByInterval(timeZone: TimeZone, timeInterval: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
    let dateFormatter = DateFormatter()
//    dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
//    dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
    dateFormatter.timeZone = timeZone
    dateFormatter.dateFormat = "HH"
//    let hour = dateFormatter.calendar.component(.hour, from: date as Date)
//    return "\(hour)"
    return dateFormatter.string(from: date)
}

func setWindDirection(degree : Float) -> String {
    let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
    let i: Int = Int((degree + 33.75)/45)
    return directions[i % 8]
}

func getDateByInterval(timeZone: TimeZone, interval: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(interval))
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: date)
}

func getDateByIntervalDetail(timeZone: TimeZone, interval: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(interval))
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    return dateFormatter.string(from: date)
}

func getWeekDayInterval(timeZone: TimeZone, interval: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(interval))
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: date)
}

// Get string for prepare video file name based on main weather condition and hour of day
func getWeatherCondition(weather: String, hour: Int) -> String {
    if weather.contains("Rain") {
        if hour >= 18 || hour <= 5 {
            return "rain_night"
        } else {
            return "rain_day"
        }
    } else if weather.contains("Snow") {
        if hour >= 18 || hour <= 5 {
            return "snow_night"
        } else {
            return "snow_day"
        }
    } else if weather.contains("Clear") {
        if hour >= 18 || hour <= 5 {
            return "clear_night"
        } else {
            return "clear_day"
        }
    } else if weather.contains("Thunderstorm") {
        if hour >= 18 || hour <= 5 {
            return "thunderstorm_night"
        } else {
            return "thunderstorm_day"
        }
    } else if weather.contains("Mist") {
        if hour >= 18 || hour <= 5 {
            return "windy_night"
        } else {
            return "windy_day"
        }
    } else if weather.contains("Clouds") {
        if hour >= 18 || hour <= 5 {
            return "cloudy_night"
        } else {
            return "cloudy_day"
        }
    } else if weather.contains("Fog") {
           if hour >= 18 || hour <= 5 {
               return "fog_night"
           } else {
               return "fog_day"
           }
    } else if weather.contains("Hot") {
               return "hot"

    } else {
        return "clear_day"
    }
}

func alertResponseError(description: String)  -> UIAlertController{
    var descriptionError = description
    if descriptionError == "" {
        descriptionError = "Unknown error"
    }
    let alert = UIAlertController(title: "Weather response error", message: descriptionError + "\nPlease check network connection", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
    NSLog("The \"OK\" alert occured.")
    }))
    return alert
}
