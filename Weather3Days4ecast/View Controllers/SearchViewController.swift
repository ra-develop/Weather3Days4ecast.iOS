//
//  SearchViewController.swift
//  Weather3Days4ecast
//
//  Created by RA on 28/03/2020.
//  Copyright © 2020 RA. All rights reserved.
//

import UIKit
import Weathersama
import Alamofire

class SearchViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate {
    
    static var instanceCitiesTableViewController: CitiesTableViewController!
    
    var searchController: UISearchController!
    
    var searchData = SearchCitiesResult()
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.list.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        
        
        // TODO setup cells for result of found cities
//        cell.textLabel?.text = self.searchData.list[indexPath.row].cityName
        
        let cityWeatherItem : CitiesListModel = self.searchData.list[indexPath.row]
                   
        cell.cityLabel.text = cityWeatherItem.cityName
        cell.countryLabel?.text = cityWeatherItem.sys.country
        cell.tempLabel?.text = (cityWeatherItem.main.temperature != nil) ? "\(Float(cityWeatherItem.main.temperature)) ºC" : "---"
        cell.descriptionLabel?.text = cityWeatherItem.weather[0].main
            
                
        getImageFromWeb(ICON_URL + cityWeatherItem.weather[0].icon + ICON_FILE_EXT) { (image) in
            if let image = image {
                cell.iconView.image = image
            } // if you use an Else statement, it will be in background
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // add selected cityID to list of city
        listCities.append(self.searchData.list[indexPath.row].cityId)
        
        // Save new list cities
        saveCitiesListItems()
        
        //Update datasource for CitiesTableView
        SearchViewController.instanceCitiesTableViewController.getWeatherMultiCities()
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    // Find request to Open Weather web site
    func findByName(searchName: String, completion: @escaping(Bool, String, AnyObject) -> ()?) {
        startRequest(url: "\(FIND_URL)\(searchName)&appid=\(APP_ID)\(TEMPERATURE_TYPES.Celcius.rawValue)", completion: completion)
    }
    
    internal func startRequest(url: String, completion: @escaping(Bool, String, AnyObject) -> ()?) {
        requestAPI(url: url) { (isSuccess, resultString, classModel) in
            completion(isSuccess, resultString, classModel!)
        }
    }

    internal func requestAPI(url: String, completion: @escaping(Bool, String, AnyObject?) -> ()) {
        Alamofire.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!).responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  {
                    let resultObj = SearchCitiesResult()
                    resultObj.parseJSON(jsonSerialized: response.result.value as AnyObject)
                    completion(true, utf8Text, resultObj)
            } else {
                completion(false, response.error.debugDescription, nil)
            }
        }
    }
    
    
    // MARK: Setup datasource
    internal func getSearchData(searchName: String) {
       findByName(searchName: searchName) { (isSuccess, description, classModel) -> () in
            if isSuccess && description != "" {
                // you can user response json or class model
                // print("response json : \(description)")
                self.searchData = (classModel as? SearchCitiesResult)!
//                for item in self.searchData.list {
//                    print("Found city: \(String(item.cityName)) ,\(String(item.sys.country))")
//                }

                self.tableView.reloadData()
            } else {
                self.present(alertResponseError(description: description), animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: UISearchbar delegate

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let searchItems = searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
                
        if searchItems.count == 0 || searchItems.last == " " {
            self.tableView.reloadData()
        } else {
            getSearchData(searchName: searchItems)
            
        }
    }

}

