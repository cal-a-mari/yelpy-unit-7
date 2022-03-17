//
//  RestaurantDetailViewController.swift
//  YelpyMari
//
//  Created by Andros Slowley on 2/8/22.
//

import AlamofireImage
import UIKit
import MapKit

protocol RestaurantDetailController: AnyObject {
  func setLeftCalloutAccessoryButton(with image: UIImage)
  func configure(with restaurant: RestaurantDetail)
  func navigate(to viewController: UIViewController)
}

final class RestaurantDetailViewController: UIViewController,
                                            RestaurantDetailController {
  private var presenter: RestaurantDetailPresenting!
  /// Photo URLs to be use for fetching Restaurant images
  private var photoURLs: [String] = []
  private var mapAnnotationView: MKAnnotationView?
  private static let annotationViewIdentifier = "MapAnnotationViewIdentifier"
  
  // MARK: IBOutlets
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var isOpenLabel: UILabel!
  @IBOutlet weak var priceRangeLabel: UILabel!
  @IBOutlet weak var imageCollectionView: UICollectionView! {
    didSet {
      imageCollectionView.dataSource = self
    }
  }
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  
  static func initialize(with restaurantID: String) -> RestaurantDetailViewController {
    let viewController = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
    viewController.presenter = RestaurantDetailPresenter(viewController: viewController,
                                                         restaurantID: restaurantID)
    return viewController
  }
  
  /// Restaurant ID used to fetch detail content
  func configure(with restaurant: RestaurantDetail) {
    mainImageView.af.setImage(withURL: URL(string: restaurant.imageURL)!)
    nameLabel.text = restaurant.name
    let isOpenText = restaurant.isClosed ? "Closed" : "Open"
    isOpenLabel.text = "Currently: \(isOpenText)"
    priceRangeLabel.text = "Expense Rating: \(restaurant.priceRange)"
    if !restaurant.categories.isEmpty {
      categoryLabel.text = "Food: \(restaurant.categories[0].title)"
    } else {
      categoryLabel.isHidden = true
    }
    photoURLs = restaurant.photos
    imageCollectionView.reloadData()
    let coordinate =
    CLLocationCoordinate2D(latitude: restaurant.coordinates["latitude"] ?? 0.0,
                           longitude: restaurant.coordinates["longitude"] ?? 0.0)
    let restaurantRegion = MKCoordinateRegion(center: coordinate,
                                              span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                     longitudeDelta: 0.01))
    mapView.setRegion(restaurantRegion, animated: true)
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = restaurant.name
    mapView.addAnnotation(annotation)
  }
  
  func navigate(to viewController: UIViewController) {
    navigationController?.pushViewController(viewController, animated: true)
  }
}

extension RestaurantDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return photoURLs.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RestaurantCollectionCell.identifier, for: indexPath) as? RestaurantCollectionCell else {
      return UICollectionViewCell()
    }
    cell.configure(with: photoURLs[indexPath.row])
    return cell
  }
}

extension RestaurantDetailViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView,
               viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    mapAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Self.annotationViewIdentifier)
    
    if mapAnnotationView == nil {
      mapAnnotationView = MKPinAnnotationView(annotation: annotation,
                                               reuseIdentifier: "AnnotationViewReuseIdentifier")
      mapAnnotationView?.canShowCallout = true
      let annotationViewButton = UIButton(frame: CGRect(x: 0.0,
                                                        y: 0.0,
                                                        width: 50.0,
                                                        height: 50.0))
      annotationViewButton.setImage(UIImage(named: "camera"), for: .normal)
      mapAnnotationView?.leftCalloutAccessoryView = annotationViewButton
    }

    return mapAnnotationView
  }
  
  func mapView(_ mapView: MKMapView,
               annotationView view: MKAnnotationView,
               calloutAccessoryControlTapped control: UIControl) {
    presenter.calloutAccessoryControlTapped()
  }
  
  func setLeftCalloutAccessoryButton(with image: UIImage) {
    let annotationViewButton = UIButton(frame: CGRect(x: 0.0,
                                                      y: 0.0,
                                                      width: 50.0,
                                                      height: 50.0))
    annotationViewButton.setImage(image, for: .normal)
    mapAnnotationView?.leftCalloutAccessoryView = annotationViewButton
  }
}
