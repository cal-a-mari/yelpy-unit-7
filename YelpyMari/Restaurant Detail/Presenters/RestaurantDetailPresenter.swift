//
//  RestaurantDetailPresenter.swift
//  YelpyMari
//
//  Created by Mari Batilando on 3/15/22.
//

import Foundation
import UIKit

protocol RestaurantDetailPresenting {
  init(viewController: RestaurantDetailController,
       restaurantID: String)
  func calloutAccessoryControlTapped()
}

class RestaurantDetailPresenter: RestaurantDetailPresenting,
                                 RestaurantImageSelectionDelegate {
  private weak var viewController: RestaurantDetailController?
  private let restaurantID: String

  required init(viewController: RestaurantDetailController,
                restaurantID: String) {
    self.viewController = viewController
    self.restaurantID = restaurantID
    RestaurantService.shared.fetchRestaurantDetail(id: restaurantID) {
      restaurantDetail in
      guard let restaurantDetail = restaurantDetail else { return }
      viewController.configure(with: restaurantDetail)
    }
  }
  
  func calloutAccessoryControlTapped() {
    let imageViewController: RestaurantImageViewController = RestaurantImageViewController.initialize()
    imageViewController.presenter.imageSelectionDelegate = self
    viewController?.navigate(to: imageViewController)
  }
  
  func didSelectImage(_ image: UIImage) {
    viewController?.setLeftCalloutAccessoryButton(with: image)
  }
}
