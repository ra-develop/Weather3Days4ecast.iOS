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


class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate var weatherSama: Weathersama!
    fileprivate var forecastModel: ForecastModel!
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
        getForecastByCityId()
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)

        // Configure the cell...

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
                print("response json : \(description)")
                self.forecastModel = classModel as? ForecastModel
                self.tableView.reloadData()
            } else {
                print("response error : \(description)")
            }
        }
        
    }
}

