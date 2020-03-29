//
//  SearchCitiesResult.swift
//  Weather3Days4ecast
//
//  Created by RA on 18/03/2020.
//  Copyright © 2020 RA. All rights reserved.
//

import Foundation


class SearchCitiesResult {
    
    private let TAG = "SearchCitiesResult"
    
    var message: String = ""
    var cod : String = ""
    var count : Int = 0
    var list : [CitiesListModel] = [CitiesListModel]()

    func parseJSON(jsonSerialized: AnyObject) {
        
        if let message = jsonSerialized["message"] as? String {
            self.message = message
        } else {
            print("\(TAG) error : JSON parse message not found")
        }
        
        if let cod = jsonSerialized["cod"] as? String {
            self.cod = cod
        } else {
            print("\(TAG) error : JSON parse cod not found")
        }
        
        if let count = jsonSerialized["count"] as? Int {
            self.count = count
        } else {
            print("\(TAG) error : JSON parse count not found")
        }
        
        if let list = jsonSerialized["list"] as? [[String: AnyObject]] {
            self.list = CitiesListModel().parseJSON(jsonArray: list)
        } else {
            print("\(TAG) error : JSON parsing list not found")
        }
        
    }
}
