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


class DetailViewController: UIViewController ,  UITableViewDataSource, UITableViewDelegate  {
    
    fileprivate var weatherSama: Weathersama!
    fileprivate var forecastModel: ForecastModel!
    var selectedCity : WeatherModel!
    var selectedCityTimeZone : TimeZone!
    var forecastSection = [(String, String)] ()
    
    // table view for Forecast viewing
    @IBOutlet var tableView: UITableView!

    // Section properties detail view of selected city
    @IBOutlet var backGroundImage: UIImageView!
    
    @IBOutlet var selectedLocaDate: UILabel!
    
    @IBOutlet var selectedLocalTime: UILabel!
    
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
        
        // Setup table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self

        getForecastByCityId()
        
        let location = CLLocationCoordinate2D(latitude: selectedCity.coordinate.latitude, longitude: selectedCity.coordinate.longitude)
        selectedCityTimeZone = TimezoneMapper.latLngToTimezone(location)
    }

    override func viewDidAppear(_ animated: Bool) {
        

        
        let fileName = getWeatherCondition(weather: selectedCity.weather[0].main, hour: Int(getHourByInterval(timeZone: selectedCityTimeZone! , timeInterval: selectedCity.dt))!)
        
        // Implement video background
        try? VideoBackground.shared.play(view: view, videoName: fileName, videoType: "mp4")
        self.backGroundImage.removeFromSuperview()
        
        selectedLocaDate.text = getDateByIntervalDetail(timeZone: selectedCityTimeZone!, interval: selectedCity.dt)
        
        selectedLocalTime.text = getTimeByInterval(timeZone: selectedCityTimeZone!, interval: selectedCity.dt)
        
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
        
        // TODO use this option when a parsed forecast
        // visibilityLabel.text = "\(Int(selectedCity.visibility)) m"

        windSpeedLabel.text = (selectedCity.wind.speed != nil) ? "\(Float(selectedCity.wind.speed)) m/c" : "---"
        
        windDegLabel.text = (selectedCity.wind.deg != nil) ? "\(setWindDirection(degree: Float(selectedCity.wind.deg))) \( (Int(selectedCity.wind.deg)))º" : "---"
       
        sunriseLabel.text = getTimeByInterval(timeZone: selectedCityTimeZone! , interval: selectedCity.sys.sunrise)

        sunsetLabel.text = getTimeByInterval(timeZone: selectedCityTimeZone!, interval: selectedCity.sys.sunset)
        
    }
    
    func numberOfSections(in tableview: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.forecastSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.forecastSection[section]
        var averageTempDay : Double = 0
        var averageTempNight : Double = 0
        var countDayTemp = 0
        var countNightTemp = 0
        let dayTemp : String!
        let nightTemp : String!
        var weekDay = ""
        
        let selectedCityToday = getDateByInterval(timeZone: self.selectedCityTimeZone, interval: self.selectedCity.dt).prefix(10)

        for listItem in self.forecastModel.list {
            if listItem.dtTxt.hasPrefix(section.0) {
                let hour : Int = Int(getHourByInterval(timeZone: self.selectedCityTimeZone, timeInterval: listItem.dt))!
                if hour >= 18 || hour <= 6 {
                    countNightTemp += 1
                    averageTempNight += listItem.main.temperature
                } else {
                    countDayTemp += 1
                    averageTempDay += listItem.main.temperature
                }
                if section.0.hasPrefix(selectedCityToday) {
                    weekDay = "Today"
                } else {
                    weekDay = "\(getWeekDayInterval(timeZone: self.selectedCityTimeZone, interval: listItem.dt))"
                }
            }

        }
        


        // Round results to decimals 2 sign if count of values != 0
        if countDayTemp != 0 {
            averageTempDay /=  Double(countDayTemp)
            averageTempDay = Double(averageTempDay*100).rounded() / 100
            dayTemp = ", Day: \(Float(averageTempDay))ºС"
        } else { dayTemp = "" }
        if countNightTemp != 0 {
            averageTempNight /=  Double(countNightTemp)
            averageTempNight = Double(averageTempNight*100).rounded() / 100
            nightTemp = ", Nihgt: \(Float(averageTempNight))ºС"
        } else { nightTemp = "" }
        
            
        return weekDay  + dayTemp + nightTemp
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let sectionIndex = section + 1
        if sectionIndex < self.forecastSection.count {
            let section = self.forecastSection[sectionIndex]
            return section.0
        }
        return "Next forecast will be soon..."
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = self.forecastSection[section]
        var countRowsInSection = 0
        for listItem in self.forecastModel.list {
            if listItem.dtTxt.hasPrefix(section.0) {
                countRowsInSection += 1
            }
        }
        return countRowsInSection
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastTableViewCell
        
        // Determine section
        let section = self.forecastSection[indexPath.section]
        
        // Determine forecast time
        let forecastTime = section.1.split(separator: " ")
        
        // Prepare and search by data and time in ForecastModel data source
        let dtSearch = section.0 + " " + forecastTime[indexPath.row]
        
        // fix a forecast item data source
        let forecastItem: ForecastListModel = forecastModel.list.first { (item : ForecastListModel) -> Bool in
            if item.dtTxt == dtSearch {
                return true
            }
            return false
            }!
        
        // Configure the cell...
        cell.forecastTimeLabel.text = String(forecastTime[indexPath.row].prefix(5))
        
        cell.forecastWeatherMainLabel.text = forecastItem.weather[0].main
        
        cell.forecastHumidityLabel.text = (forecastItem.main.humidity != nil) ? "\(Float(forecastItem.main.humidity)) %" : "---"
        
        cell.forecastMainTempMax.text = (forecastItem.main.temperatureMax != nil) ? "\(Float(forecastItem.main.temperatureMax)) ºC" : "---"
        
        cell.forecastMainTempMin.text = (forecastItem.main.temperatureMin != nil) ? "\(Float(forecastItem.main.temperatureMin)) ºC" : "---"
                
        getImageFromWeb(ICON_URL + forecastItem.weather[0].icon + ICON_FILE_EXT) { (image) in
            if let image = image {
                cell.forecastIconImage.image = image
            } // if you use an Else statement, it will be in background
        }
        

        return cell
    }
    

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Getting forecast for selected city
    func getForecastByCityId() {
        // Setup and request list of forecast of cities
        weatherSama = Weathersama(appId: APP_ID, temperature: TEMPERATURE_TYPES.Celcius, language: LANGUAGES.English, dataResponse: DATA_RESPONSE.JSON)
        weatherSama.weatherByCityId(cityId: selectedCity.cityId, requestType: .Forecast) { (isSuccess, description, classModel) -> () in
            if isSuccess {
                
                // Load parsed model form JSON
                self.forecastModel = classModel as? ForecastModel

                // Variable for preparing section of tableview
                // main data source for section view
                var tempDictionary = [String: String] ()
                
                // Determinate loacal date for selected city
                
                // Prepare section data source based on date and weekday
                for listItem in self.forecastModel.list {
                    // Composition for header of section view
                    let tempString = tempDictionary [String(listItem.dtTxt.prefix(10))]
                    tempDictionary [String(listItem.dtTxt.prefix(10))] = (tempString != nil ? tempString! : "") +
                    " \(String(listItem.dtTxt.suffix(8)))"
                }
                
                // Sorting result for section data source
                self.forecastSection =  tempDictionary.sorted(by: <)
                
                // reload tableView
                self.tableView?.reloadData()
            } else {
                print("response error : \(description)")
            }
        }
        
    }
}

