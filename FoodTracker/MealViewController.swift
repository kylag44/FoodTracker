//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Kyla  on 2018-09-07.
//  Copyright © 2018 Kyla . All rights reserved.
//

import UIKit
import os.log

///add in the textfield delegate. you tell the compiler that the ViewController class can act as a valid text field delegate. This means you can implement the protocol’s methods to handle text input, and you can assign instances of the ViewController class as the delegate of the text field.
@IBDesignable class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  //MARK: Properties
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var ratingControl: RatingControl!
  @IBOutlet weak var saveButton: UIBarButtonItem!
 
  @IBOutlet weak var mealDescriptionTextField: UITextField!
  @IBOutlet weak var caloriesTextField: UITextField!
  
   /*
   This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
   or constructed as part of adding a new meal.
   */
  var meal: Meal?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Handle the text field’s user input through delegate callbacks.
    nameTextField.delegate = self
    
    ///Below the nameTextField.delegate line, add the following code. If the meal property is non-nil, this code sets each of the views in MealViewController to display data from the meal property. The meal property will only be non-nil when an existing meal is being edited.
    // Set up views if editing an existing Meal.
    if let meal = meal {
      navigationItem.title = meal.name
      nameTextField.text   = meal.name
      photoImageView.image = meal.photo
      ratingControl.rating = meal.rating
      
      mealDescriptionTextField.text = meal.mealDescription
      caloriesTextField.text = "\(meal.calories)"
    }
    
    // Enable the Save button only if the text field has a valid Meal name.
    updateSaveButtonState()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // Hide the keyboard.
    textField.resignFirstResponder()
    return true
  }
  

  func textFieldDidEndEditing(_ textField: UITextField) {
      updateSaveButtonState()
      navigationItem.title = textField.text
    }
  
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // Disable the Save button while editing.
    saveButton.isEnabled = false
  }
  
  //MARK: UIImagePickerControllerDelegate
///imagePickerControllerDidCancel(_:), gets called when a user taps the image picker’s Cancel button. This method gives you a chance to dismiss the UIImagePickerController (and optionally, do any necessary cleanup).
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    // Dismiss the picker if the user canceled.
    dismiss(animated: true, completion: nil)
  }
  
  ///The second UIImagePickerControllerDelegate method that you need to implement, imagePickerController(_:didFinishPickingMediaWithInfo:), gets called when a user selects a photo. This method gives you a chance to do something with the image or images that a user selected from the picker. In your case, you’ll take the selected image and display it in your image view.
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    // The info dictionary may contain multiple representations of the image. You want to use the original.
    guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
      fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    }
    // Set photoImageView to display the selected image.
    photoImageView.image = selectedImage
    // Dismiss the picker.
    dismiss(animated: true, completion: nil)
  }
  
  //MARK: Navigation
  @IBAction func cancel(_ sender: UIBarButtonItem) {
    // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
    let isPresentingInAddMealMode = presentingViewController is UINavigationController
    
    if isPresentingInAddMealMode {
      dismiss(animated: true, completion: nil)
    }
    else if let owningNavigationController = navigationController{
      owningNavigationController.popViewController(animated: true)
    }
    else {
      fatalError("The MealViewController is not inside a navigation controller.")
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    guard let button = sender as? UIBarButtonItem, button === saveButton else {
      os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
      return
    }
    let name = nameTextField.text ?? ""
    let photo = photoImageView.image
    let rating = ratingControl.rating
    
    let mealDescription = mealDescriptionTextField.text ?? ""
    let calories = Int(caloriesTextField.text!) ?? 0
    // Set the meal to be passed to MealTableViewController after the unwind segue.
//    meal = Meal(name: name, photo: photo, rating: rating, calories: nil, mealDescription: nil)
    meal = Meal(name: name, photo: photo, rating: rating, calories: calories, mealDescription: mealDescription)
  }

  //MARK: Actions
  @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
    /// Hide the keyboard.
    nameTextField.resignFirstResponder()
    /// UIImagePickerController is a view controller that lets a user pick media from their photo library. creates an imagepicker controller
    let imagePickerController = UIImagePickerController()
    /// Only allow photos to be picked, not taken.
///  This line of code sets the image picker controller’s source, or the place where it gets its images. The .photoLibrary option uses the simulator’s camera roll.
    imagePickerController.sourceType = .photoLibrary
    ///this code to set the image picker controller’s delegate to ViewController:
    /// Make sure ViewController is notified when the user picks an image.
    imagePickerController.delegate = self
///    present(_:animated:completion:) is a method being called on ViewController. Although it’s not written explicitly, this method is executed on an implicit self object. The method asks ViewController to present the view controller defined by imagePickerController. Passing true to the animated parameter animates the presentation of the image picker controller. The completion parameter refers to a completion handler, a piece of code that executes after this method completes. Because you don’t need to do anything else, you indicate that you don’t need to execute a completion handler by passing in nil.
    present(imagePickerController, animated: true, completion: nil)
  }
  
//MARK: Private Methods
  private func updateSaveButtonState() {
    // Disable the Save button if the text field is empty.
    let text = nameTextField.text ?? ""
    saveButton.isEnabled = !text.isEmpty
  }
}

