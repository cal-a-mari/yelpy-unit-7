//
//  RestaurantImageViewController.swift
//  YelpyMari
//
//  Created by Mari Batilando on 3/2/22.
//

import UIKit

protocol RestaurantImageViewControlling: AnyObject {
  func showImagePicker()
  func setChosenImage(_ image: UIImage)
  func dismiss()
}

class RestaurantImageViewController: UIViewController,
                                     RestaurantImageViewControlling {
  
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var chooseImageButton: UIButton!
  
  var presenter: RestaurantImagePresenting!
  
  static func initialize() -> RestaurantImageViewController {
    let viewController = UIStoryboard(name: "Main", bundle: nil)
      .instantiateViewController(withIdentifier: "RestaurantImageViewController") as! RestaurantImageViewController
    viewController.presenter = RestaurantImagePresenter(viewController: viewController)
    return viewController
  }
  
  @IBAction func didTapChooseImageButton(_ sender: UIButton) {
    presenter.didTapChooseImageButton()
  }
  
  func showImagePicker() {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera)
      ? .camera
      : .photoLibrary
    present(imagePicker, animated: true, completion: nil)
  }
  
  func setChosenImage(_ image: UIImage) {
    imageView.image = image
  }
  
  func dismiss() {
    dismiss(animated: true)
  }
}

extension RestaurantImageViewController: UIImagePickerControllerDelegate,
                                         UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    presenter.didFinishPickingImage(withInfo: info)
  }
}
