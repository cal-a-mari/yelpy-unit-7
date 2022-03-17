//
//  ViewController.swift
//  YelpyMari
//
//  Created by Mari Batilando on 1/12/22.
//

import UIKit

class RestaurantsViewController: UIViewController,
                                 UITableViewDelegate,
                                 UITableViewDataSource,
                                 RestaurantsController {
  @IBOutlet weak var tableView: UITableView!
  private var presenter: RestaurantsPresenting!
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    presenter = RestaurantsPresenter(restaurantsController: self)
    navigationItem.title = "Restaurants"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return presenter.restaurants.count
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.didTapRestaurantAt(indexPath: indexPath)
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantTableViewCell.cellIdentifier) as? RestaurantTableViewCell else {
      return UITableViewCell()
    }
    cell.configure(with: presenter.restaurants[indexPath.row])
    return cell
  }
  
  func navigate(to viewController: UIViewController) {
    self.navigationController?.pushViewController(viewController,
                                                  animated: true)
  }
  
  func reloadData() {
    tableView.reloadData()
  }
}
