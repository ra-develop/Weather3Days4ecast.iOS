//
//  CitiesTableViewController.swift
//  Weather3Days4ecast
//
//  Created by RA on 18/03/2020.
//  Copyright © 2020 RA. All rights reserved.
//

import UIKit
import Weathersama


class CitiesTableViewController: UITableViewController {
    
    fileprivate var weatherSama: Weathersama!
    fileprivate var weatherModelList: [WeatherModel] = []
    var cityToBeDetail: WeatherModel! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = getCurentDate()

        getWeatherMultiCities()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableview: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return weatherModelList.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell  = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityWeatherCell

        // Configure the cell...
        
        let cityWeatherItem : WeatherModel = weatherModelList[indexPath.row]
           
        cell.cityName.text = cityWeatherItem.cityName
        cell.countryCode?.text = cityWeatherItem.sys.country
        cell.mainTemperature?.text = "\(Float(cityWeatherItem.main.temperature)) ºC"
//        cell.mainTempMax?.text = "\(Float(cityWeatherItem.main.temperatureMax))"
//        cell.mainTempMin?.text = "\(Float(cityWeatherItem.main.temperatureMin))"
        cell.weatherDesription?.text = cityWeatherItem.weather[0].description
        
// first metod for load image from web- not secure
//        let imageURL = NSURL(string: ICON_URL + cityWeatherItem.weather[0].icon + ICON_FILE_EXT)
//        let imagedData = NSData(contentsOf: imageURL! as URL)!
//        cell.weatherIcon?.image = UIImage(data: imagedData as Data)
        
        getImageFromWeb(ICON_URL + cityWeatherItem.weather[0].icon + ICON_FILE_EXT) { (image) in
            if let image = image {
                cell.weatherIcon.image = image
            } // if you use an Else statement, it will be in background
        }
        
        return cell

    }
    
    @IBAction func Reload(_ sender: Any) {
        self.tableView.reloadData()
        print("Elements in listing : \(self.weatherModelList.count)")
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowDetail") {
            let indexPath =  self.tableView.indexPathForSelectedRow
            let cityWeatherItem : WeatherModel = weatherModelList[indexPath!.row]
            cityToBeDetail = cityWeatherItem
                   let detailCityWeather = segue.destination as! DetailViewController
                    
                   detailCityWeather.selectedCity = cityToBeDetail
        }
    }

    
    
    // Getting weather of milti cities based on constant list of cities
    func getWeatherMultiCities() {
        // Setup and request list of weather of cities
        weatherSama = Weathersama(appId: APP_ID, temperature: TEMPERATURE_TYPES.Celcius, language: LANGUAGES.English, dataResponse: DATA_RESPONSE.JSON)
        for index in listCities {
            weatherSama.weatherByCityId(cityId: index, requestType: .Weather) { (isSuccess, description, classModel) -> () in
                if isSuccess {
                    // you can user response json or class model
//                    print("response json : \(description)")
                    self.weatherModelList.append(classModel as! WeatherModel)
//                    print("Loop N : \(self.weatherModelList.count)")
//                    print("Row in view : \(self.tableView.numberOfRows(inSection: 0))")
                    self.tableView.reloadData()
                    //                    print(self.weatherModelList.last?.cityName ?? String())
                    //                    print(self.weatherModelList.last?.main.temperature ?? Float())
                    //                    print(self.weatherModelList.last?.weather[0].main ?? String())
                    //                    print(self.weatherModelList.last?.weather[0].description ?? String())
                    
                } else {
                    print("response error : \(description)")
                }
            }
        }
        
    }

}
