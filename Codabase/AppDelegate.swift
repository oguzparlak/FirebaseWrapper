//
//  AppDelegate.swift
//  Codabase
//
//  Created by Oğuz Parlak on 11.10.2020.
//

import UIKit
import Firebase

protocol RestaurantInteractorDelegate: class {
    
    func onNewRestaurantPosted(restaurant: Restaurant?)
    func onRestaurantsRetrieved(restaurants: [Restaurant]?)
    func onRestaurantDetailFetched(restaurant: Restaurant?)
    func onRestaurantDeleted(with id: String)
    func onError(error: Error)
    
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    weak var delegate: RestaurantInteractorDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        // deleteRestaurant(with: "FCACE5C9-3244-4FAA-AD17-3682B3B6ADF4")
        
        // let restaurant = RestaurantDataSource().createDummyRestaurant(with: UUID().uuidString)
        // postRestaurant(restaurant: restaurant)
        
        deleteRestaurant(with: "59129E27-F5C7-4E04-82AC-D66380D7169D")
        
        return true
    }
    
    private func deleteRestaurant(with id: String) {
        RestaurantsEndpoint.deleteRestaurant(id: id).remove { [weak self] in
            self?.delegate?.onRestaurantDeleted(with: id)
        } onError: { [weak self] error in
            self?.delegate?.onError(error: error)
        }
    }
    
    private func postRestaurant(restaurant: Restaurant?) {
        guard let restaurantId: String = restaurant?.id else { return }
        RestaurantsEndpoint.postRestaurant(id: restaurantId).post(data: restaurant, createNewKey: false) { [weak self] result in
            switch result {
            case .success(let restaurant):
                self?.delegate?.onNewRestaurantPosted(restaurant: restaurant)
            case .failure(let error):
                self?.delegate?.onError(error: error)
            }
        }
    }
    
    private func getAllRestaurants() {
        RestaurantsEndpoint.getAllRestaurants.retrieve(completion: { [weak self] (restaurants: [Restaurant]?) in
            self?.delegate?.onRestaurantsRetrieved(restaurants: restaurants)
        }) { [weak self] error in
            self?.delegate?.onError(error: error)
        }
    }
    
    private func getRestaurantDetail(with id: String) {
        RestaurantsEndpoint.getRestaurantDetail(id: id).retrieve(completion: { [weak self] (restaurant: Restaurant?) in
            self?.delegate?.onRestaurantDetailFetched(restaurant: restaurant)
        }) { [weak self] error in
            self?.delegate?.onError(error: error)
        }
    }

}

