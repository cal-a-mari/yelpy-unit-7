//
//  RestaurantsListPresenter.swift
//  YelpyMari
//
//  Created by Mari Batilando on 3/15/22.
//

import Foundation
import UIKit

protocol RestaurantsListPresenting {
  var restaurants: [RestaurantListItem] { get }
  func didTapRestaurantAt(indexPath: IndexPath)
}

class RestaurantsListPresenter: RestaurantsListPresenting {
  var restaurants = [RestaurantListItem]() {
    didSet {
      restaurantsViewController?.reloadData()
    }
  }
  weak var restaurantsViewController: RestaurantsViewControlling?
  
  init(restaurantsViewController: RestaurantsViewControlling) {
    self.restaurantsViewController = restaurantsViewController
    RestaurantService.shared.fetchRestaurants { restaurants in
      self.restaurants = restaurants
    }
  }
  
  func didTapRestaurantAt(indexPath: IndexPath) {
    let detailViewController = RestaurantDetailViewController.initialize(with: restaurants[indexPath.row].id)
    restaurantsViewController?.navigate(to: detailViewController)
  }
}
