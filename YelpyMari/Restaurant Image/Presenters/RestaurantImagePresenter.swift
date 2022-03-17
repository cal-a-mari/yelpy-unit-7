//
//  RestaurantImagePresenter.swift
//  YelpyMari
//
//  Created by Mari Batilando on 3/16/22.
//

import UIKit

protocol RestaurantImageSelectionDelegate: AnyObject {
  func didSelectImage(_ image: UIImage)
}

protocol RestaurantImagePresenting {
  var imageSelectionDelegate: RestaurantImageSelectionDelegate? { get set }
  func didTapChooseImageButton()
  func didFinishPickingImage(withInfo info: [UIImagePickerController.InfoKey : Any])
}

class RestaurantImagePresenter: RestaurantImagePresenting {
  weak var imageSelectionDelegate: RestaurantImageSelectionDelegate?
  weak var viewController: RestaurantImageController?
  
  init(viewController: RestaurantImageController) {
    self.viewController = viewController
  }
  
  func didTapChooseImageButton() {
    viewController?.showImagePicker()
  }
  
  func didFinishPickingImage(withInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else { return }
    imageSelectionDelegate?.didSelectImage(image)
    viewController?.setChosenImage(image)
    viewController?.dismiss()
  }
}


