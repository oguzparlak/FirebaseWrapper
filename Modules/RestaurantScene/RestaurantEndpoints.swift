//
//  RestaurantEndpoints.swift
//  Codabase
//
//  Created by Oğuz Parlak on 11.10.2020.
//

import Foundation

enum RestaurantsEndpoint: FirebaseDatabaseEndpoint {
    
    case getAllRestaurants
    case postRestaurant(id: String)
    case getRestaurantDetail(id: String)
    case deleteRestaurant(id: String)
    
    var path: String {
        switch self {
        case .getAllRestaurants:
            return "restaurants"
        case .postRestaurant(let id), .getRestaurantDetail(let id), .deleteRestaurant(let id):
            return "restaurants/\(id)"
        }
    }
    
    var synced: Bool {
        switch self {
        case .getAllRestaurants, .getRestaurantDetail:
            return true
        case .postRestaurant, .deleteRestaurant:
            return false
        }
    }
    
}
