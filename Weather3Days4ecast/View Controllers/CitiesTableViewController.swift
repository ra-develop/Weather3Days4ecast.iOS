//
//  CitiesTableViewController.swift
//  Weather3Days4ecast
//
//  Created by RA on 18/03/2020.
//  Copyright © 2020 RA. All rights reserved.
//

import UIKit
import Weathersama
import CoreLocation


class CitiesTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet var activityIndicatorLabel: UIActivityIndicatorView!
    
    
    fileprivate var weatherSama: Weathersama!
    fileprivate var weatherModelList: [WeatherModel] = []
    var cityToBeDetail: WeatherModel! = nil
    let backgroundImage = UIImageView(image: UIImage(named: "johannes-plenio-600dw3-1rv4-unsplash.jpg"))
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCitiesListItems()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        getWeatherMultiCities()
        
        self.title = getCurentDateWithWeekDay()
     
        // Loading and framing background image
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.layer.frame = CGRect(x: -1202, y: 0, width: 1616, height: tableView.frame.height)
        let backgroundImageView = UIView()
        backgroundImageView.addSubview(backgroundImage)
        tableView.backgroundView = backgroundImageView

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Control of background image animation
       
        
        let initialBackgroundImageFrame = backgroundImage.frame
        UIView.animate(withDuration: 60.0, delay: 1.0, options: [.curveEaseOut, .curveEaseIn, .autoreverse, .repeat] , animations: {
            var backgroundImageFrame = self.backgroundImage.frame
            backgroundImageFrame.origin.x += self.backgroundImage.layer.frame.size.width - self.view.bounds.width

            self.backgroundImage.frame = backgroundImageFrame
        }, completion: { finished in  self.backgroundImage.frame = initialBackgroundImageFrame  })
                      
        locationManager.requestLocation()

    }

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
        cell.mainTemperature?.text = (cityWeatherItem.main.temperature != nil) ? "\(Float(cityWeatherItem.main.temperature)) ºC" : "---"
        cell.weatherDesription?.text = cityWeatherItem.weather[0].main
        
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
        locationManager.requestLocation()
        self.tableView.reloadData()
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            listCities.removeAll(where: {$0 == weatherModelList[indexPath.row].cityId})
            weatherModelList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveCitiesListItems()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        self.tableView.reloadData()
    }
    

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

    // Getting user location of geo position.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (locations.last != nil) {
            currentLocation = locations.last?.coordinate
            weatherSama.weatherByCoordinate(coordinate: currentLocation, requestType: .Weather) { (isSuccess, description, classModel) -> () in
                if isSuccess && description != ""{
                    // you can user response json or class model
                    //                    print("response json : \(description)")
                    let localCityWeatherModel = classModel as! WeatherModel
                    if !self.weatherModelList.isEmpty {
                        if self.weatherModelList[0].cityName.prefix(1) != "⦿" {
                            listCities.insert(localCityWeatherModel.cityId, at: 0)
                            self.weatherModelList.insert(localCityWeatherModel, at: 0)
                        } else {
                            listCities[0] = localCityWeatherModel.cityId
                            self.weatherModelList[0] = localCityWeatherModel
                        }
                    } else {
                        listCities.append(localCityWeatherModel.cityId)
                        self.weatherModelList.append(localCityWeatherModel)
                    }
                    self.weatherModelList[0].cityName = "⦿ " + self.weatherModelList[0].cityName
                    self.activityIndicatorLabel.stopAnimating()
                    self.tableView.reloadData()
                } else {
                    
                    self.present(alertResponseError(description: description), animated: true, completion: nil)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    
    // Getting weather of milti cities based on constant list of cities
    func getWeatherMultiCities() {
        // Setup and request list of weather of cities
        weatherSama = Weathersama(appId: APP_ID, temperature: TEMPERATURE_TYPES.Celcius, language: LANGUAGES.English, dataResponse: DATA_RESPONSE.JSON)
        for index in listCities {
            weatherSama.weatherByCityId(cityId: index, requestType: .Weather) { (isSuccess, description, classModel) -> () in
                if isSuccess && description != "" {
                    // you can user response json or class model
                    // print("response json : \(description)")
                    self.weatherModelList.append(classModel as! WeatherModel)
                    self.weatherModelList = self.weatherModelList.sorted(by: { (initial:WeatherModel , next:WeatherModel) -> Bool in return initial.cityName.compare(next.cityName) == .orderedAscending})
                } else {
                    self.present(alertResponseError(description: description), animated: true, completion: nil)
                }
            }
        }
        self.tableView.reloadData()
    }

    func documetsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documetsDirectory().appendingPathComponent("Cities.plist")
    }
    
    func saveCitiesListItems() {
//        print("File will be save to: \(dataFilePath())")
        (listCities as NSArray).write(to: dataFilePath(), atomically: true)
    }
    
    func loadCitiesListItems() {
        listCities = NSArray(contentsOf: dataFilePath()) as? [Int] ?? []
    }
}
