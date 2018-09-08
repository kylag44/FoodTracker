//
//  Meal.swift
//  FoodTracker
//
//  Created by Kyla  on 2018-09-07.
//  Copyright © 2018 Kyla . All rights reserved.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
  
  //MARK: Properties
//   create a structure to store the key strings. This way, when you need to use the key in multiple places throughout your code, you can use the constant instead of retyping the string (which increases the likelihood of mistakes).
  struct PropertyKey {
    ///Each constant corresponds to one of the three properties of Meal. The static keyword indicates that these constants belong to the structure itself, not to instances of the structure. You access these constants using the structure’s name (for example, PropertyKey.name)
    static let name = "name"
    static let photo = "photo"
    static let rating = "rating"
  }
  
  ///This code defines the basic properties for the data you need to store. You’re making these variables (var) instead of constants (let) because they’ll need to change throughout the course of a Meal object’s lifetime.
  var name: String
  var photo: UIImage?
  var rating: Int
  
  //MARK: Archiving Paths
  static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
  
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
  
  //MARK: NSCoding
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: PropertyKey.name)
    aCoder.encode(photo, forKey: PropertyKey.photo)
    aCoder.encode(rating, forKey: PropertyKey.rating)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    // The name is required. If we cannot decode a name string, the initializer should fail.
    guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
      os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
      return nil
    }
    // Because photo is an optional property of Meal, just use conditional cast.
    let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
    
    let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
    
    // Must call designated initializer.
    self.init(name: name, photo: photo, rating: rating)
  }
  
}
