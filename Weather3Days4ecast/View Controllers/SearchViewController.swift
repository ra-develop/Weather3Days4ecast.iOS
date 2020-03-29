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

class SearchViewController: UIViewController {
    
    var searchController: UISearchController!
    
    var searchData: SearchCitiesResult!
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        findByName(searchName: "Milan") { (isSuccess, description, classModel) -> () in
            if isSuccess && description != "" {
                // you can user response json or class model
                // print("response json : \(description)")
                self.searchData = classModel as? SearchCitiesResult
                for item in self.searchData.list {
                    print("Found city: \(String(item.cityName)) \(String(item.sys.country))")
                }
                print("Count of found cities: \(self.searchData.count)")
            } else {
                self.present(alertResponseError(description: description), animated: true, completion: nil)
            }
        }


    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    
    func findByName(searchName: String, completion: @escaping(Bool, String, AnyObject) -> ()?) {
        startRequest(url: "\(FIND_URL)\(searchName)&appid=\(APP_ID)", completion: completion)
    }
    
    internal func startRequest(url: String, completion: @escaping(Bool, String, AnyObject) -> ()?) {
        requestAPI(url: url) { (isSuccess, resultString, classModel) in
            completion(isSuccess, resultString, classModel!)
        }
    }

    internal func requestAPI(url: String, completion: @escaping(Bool, String, AnyObject?) -> ()) {
        Alamofire.request(url).responseJSON { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  {
                    let resultObj = SearchCitiesResult()
                    resultObj.parseJSON(jsonSerialized: response.result.value as AnyObject)
                    completion(true, utf8Text, resultObj)
            } else {
                completion(false, response.error.debugDescription, nil)
            }
        }
    }

}

