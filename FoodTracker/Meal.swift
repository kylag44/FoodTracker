//
//  Meal.swift
//  FoodTracker
//
//  Created by Kyla  on 2018-09-07.
//  Copyright © 2018 Kyla . All rights reserved.
//

import UIKit

class Meal {
  
  //MARK: Properties
  ///This code defines the basic properties for the data you need to store. You’re making these variables (var) instead of constants (let) because they’ll need to change throughout the course of a Meal object’s lifetime.
  var name: String
  var photo: UIImage?
  var rating: Int
  
  //MARK: Initialization
  
  init?(name: String, photo: UIImage?, rating: Int) {
    // The name must not be empty
    ///A guard statement declares a condition that must be true in order for the code after the guard statement to be executed. If the condition is false, the guard statement’s else branch must exit the current code block (for example, by calling return, break, continue, throw, or a method that doesn’t return like fatalError(_:file:line:)).
    guard !name.isEmpty else {
      return nil
    }
    // The rating must be between 0 and 5 inclusively
    guard (rating >= 0) && (rating <= 5) else {
      return nil
    }
    // Initialize stored properties.
    self.name = name
    self.photo = photo
    self.rating = rating
  }
  
}
