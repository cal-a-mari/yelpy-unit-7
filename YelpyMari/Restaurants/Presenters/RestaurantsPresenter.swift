//
//  RestaurantsPresenter.swift
//  YelpyMari
//
//  Created by Mari Batilando on 3/15/22.
//

import Foundation
import UIKit

protocol RestaurantsPresenting {
  var restaurants: [RestaurantItem] { get }
  func didTapRestaurantAt(indexPath: IndexPath)
}

class RestaurantsPresenter: RestaurantsPresenting {
  var restaurants = [RestaurantItem]() {
    didSet {
      restaurantsController?.reloadData()
    }
  }
  weak var restaurantsController: RestaurantsController?
  
  init(restaurantsController: RestaurantsController) {
    self.restaurantsController = restaurantsController
    RestaurantService.shared.fetchRestaurants { restaurants in
      self.restaurants = restaurants
    }
  }
  
  func didTapRestaurantAt(indexPath: IndexPath) {
    let detailViewController = RestaurantDetailViewController.initialize(with: restaurants[indexPath.row].id)
    restaurantsController?.navigate(to: detailViewController)
  }
}
