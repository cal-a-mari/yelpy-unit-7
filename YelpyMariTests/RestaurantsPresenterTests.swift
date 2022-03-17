//
//  RestaurantsPresenterTests.swift
//  YelpyMariTests
//
//  Created by Mari Batilando on 3/16/22.
//

import XCTest
@testable import YelpyMari

class MockRestaurantsController: RestaurantsController {
  var calledNavigateTo = false
  var calledReloadData = false
  
  func navigate(to viewController: UIViewController) {
    calledNavigateTo = true
  }
  
  func reloadData() {
    calledReloadData = true
  }
}

class MockRestaurantService: RestaurantServiceProtocol {
  func fetchRestaurants(completion: @escaping (([RestaurantItem]) -> Void)) {
    completion([RestaurantItem(id: "1",
                               name: "Test Name 1",
                               type: "Some Type",
                               rating: 3,
                               phoneNumber: "123-456-7890",
                               imageURL: "some url")])
  }
  
  func fetchRestaurantDetail(id: String,
                             completion: @escaping ((RestaurantDetail?) -> Void)) {
    completion(RestaurantDetail(name: "Test Name 1",
                                imageURL: "",
                                isClosed: false,
                                priceRange: "",
                                categories: [],
                                photos: [],
                                coordinates: [:]))
  }
}

class RestaurantsPresenterTests: XCTestCase {
  var mockRestaurantsController: MockRestaurantsController!
  var mockRestaurantService: MockRestaurantService!
  
  override func setUpWithError() throws {
    mockRestaurantsController = MockRestaurantsController()
    mockRestaurantService = MockRestaurantService()
  }
  
  func testNavigateToGetsCalledAfterTappingOnARestaurant() throws {
    let restaurantsPresenter = RestaurantsPresenter(restaurantsController: mockRestaurantsController,
                                                    restaurantService: mockRestaurantService)
    restaurantsPresenter.didTapRestaurantAt(indexPath: IndexPath(row: 0, section: 0))
    XCTAssert(mockRestaurantsController.calledNavigateTo)
  }
  
  func testReloadDataGetsCalledAfterFetchingData() throws {
    let _ = RestaurantsPresenter(restaurantsController: mockRestaurantsController,
                                 restaurantService: mockRestaurantService)
    XCTAssert(mockRestaurantsController.calledReloadData)
  }
}
