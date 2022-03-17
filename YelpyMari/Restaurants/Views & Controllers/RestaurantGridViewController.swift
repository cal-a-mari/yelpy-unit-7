//
//  RestaurantGridViewController.swift
//  YelpyMari
//
//  Created by Andros Slowley on 2/10/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class RestaurantGridViewController: UICollectionViewController,
                                    RestaurantsController {
  private var presenter: RestaurantsPresenting!
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    presenter = RestaurantsPresenter(restaurantsController: self)
    navigationItem.title = "Restaurants"
  }
  
  // MARK: UICollectionViewDataSource  
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return presenter.restaurants.count
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
    presenter.didTapRestaurantAt(indexPath: indexPath)
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionCell.identifier, for: indexPath) as? RestaurantCollectionCell else {
      return UICollectionViewCell()
    }
    cell.configure(with: presenter.restaurants[indexPath.row].imageURL)
    return cell
  }
  
  func navigate(to viewController: UIViewController) {
    self.navigationController?.pushViewController(viewController,
                                                  animated: true)
  }
  
  func reloadData() {
    collectionView.reloadData()
  }
}
