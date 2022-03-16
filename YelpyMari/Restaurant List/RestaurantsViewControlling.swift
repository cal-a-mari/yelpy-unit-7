//
//  RestaurantsViewControlling.swift
//  YelpyMari
//
//  Created by Mari Batilando on 3/16/22.
//

import UIKit

protocol RestaurantsViewControlling: AnyObject {
  func navigate(to viewController: UIViewController)
  func reloadData()
}
