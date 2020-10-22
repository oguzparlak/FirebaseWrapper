//
//  LocalDataSource.swift
//  Codabase
//
//  Created by Oğuz Parlak on 18.10.2020.
//

import Foundation

protocol RestaurantDataSourceProtocol {
    
    func createDummyRestaurant(with id: String) -> Restaurant
    
}

struct RestaurantDataSource: RestaurantDataSourceProtocol {
    
    func createDummyRestaurant(with id: String) -> Restaurant {
        return Restaurant(id: id,
                          name: "Nusr-et",
                          lat: 34.232,
                          lon: 26.785)
    }
    
}
