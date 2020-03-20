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
func getCurentDate () -> String {
    let date = Calendar.current.date(byAdding: .day, value: 0, to: Date())
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM, dd, yyyy"
    
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
    dateFormatter.dateFormat = "HH:mm:ss"
    return dateFormatter.string(from: date)
}

func setWindDirection(degree : Float) -> String {
    let directions = ["Nord", "Nord-East", "East", "South-East", "South", "South-West", "West", "Nord-West"]
    let i: Int = Int((degree + 33.75)/45)
    return directions[i % 8]
}

func getDateByInterval(timeZone: TimeZone, interval: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(interval))
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = timeZone
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
}
