//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Kyla  on 2018-09-07.
//  Copyright © 2018 Kyla . All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
  
  //MARK: Properties
  ///This code declares a property on MealTableViewController and initializes it with a default value (an empty array of Meal objects). By making meals a variable (var) instead of a constant, you make the array mutable, which means you can add items to it after you initialize it.
  var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      // Use the edit button item provided by the table view controller.
      ///This code creates a special type of bar button item that has editing behavior built into it. It then adds this button to the left side of the navigation bar in the meal list scene
      navigationItem.leftBarButtonItem = editButtonItem
      // Load any saved meals, otherwise load sample data.
      if let savedMeals = loadMeals() {
        meals += savedMeals
      }
      else {
        // Load the sample data.
        loadSampleMeals()
      }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      ///return array
        return meals.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      // Table view cells are reused and should be dequeued using a cell identifier.
      let cellIdentifier = "MealTableViewCell"
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
        fatalError("The dequeued cell is not an instance of MealTableViewCell.")
      }
      
      // Fetches the appropriate meal for the data source layout.
      let meal = meals[indexPath.row]
      
      cell.nameLabel.text = meal.name
      cell.photoImageView.image = meal.photo
      cell.ratingControl.rating = meal.rating
      
      return cell
    }
 

  
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
          ///This code removes the Meal object to be deleted from meals.
            meals.remove(at: indexPath.row)
          ///This code saves the meals array whenever a meal is deleted.
            saveMeals()
          ///is part of the template implementation, deletes the corresponding row from the table view
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
  

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      super.prepare(for: segue, sender: sender)
   
      switch(segue.identifier ?? "") {
        
      case "AddItem":
        os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        
      case "ShowDetail":
        guard let mealDetailViewController = segue.destination as? MealViewController else {
          fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedMealCell = sender as? MealTableViewCell else {
          fatalError("Unexpected sender: \(sender)")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
          fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedMeal = meals[indexPath.row]
        mealDetailViewController.meal = selectedMeal
        
      default:
        fatalError("Unexpected Segue Identifier; \(segue.identifier)")
      }
    }
 
  
  //MARK: Actions
  @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
      
      if let selectedIndexPath = tableView.indexPathForSelectedRow {
        // Update an existing meal.
        meals[selectedIndexPath.row] = meal
        tableView.reloadRows(at: [selectedIndexPath], with: .none)
      }
      else {
        // Add a new meal.
        let newIndexPath = IndexPath(row: meals.count, section: 0)
        
        meals.append(meal)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
      }
      // Save the meals.
      saveMeals()
    }
  }
  
  
  //MARK: Private Methods
  
  private func loadSampleMeals() {
    let photo1 = UIImage(named: "brownie")
    let photo2 = UIImage(named: "chickenParm")
//    let photo3 = UIImage(named: "fries")
//    let photo4 = UIImage(named: "funnelCake")
//    let photo5 = UIImage(named: "margarita")
//    let photo6 = UIImage(named: "pizza")
//    let photo7 = UIImage(named: "taco")
//    let photo8 = UIImage(named: "triple burger")
//    let photo9 = UIImage(named: "wings")
    
    guard let meal1 = Meal(name: "Brownie", photo: photo1, rating: 4, calories: 400, mealDescription: "So tasty and worth putting on fat!") else {
      fatalError("Unable to instantiate meal1")
    }
    
    guard let meal2 = Meal(name: "Chicken Parmesan", photo: photo2, rating: 5, calories: 700, mealDescription: "Give me more please!") else {
      fatalError("Unable to instantiate meal1")
    }
//    guard let meal1 = Meal(name: "Brownie", photo: photo1, rating: 4) else {
//      fatalError("Unable to instantiate meal1")
//    }
//
//    guard let meal2 = Meal(name: "Chicken Parmesan", photo: photo2, rating: 5) else {
//      fatalError("Unable to instantiate meal2")
//    }
//
//    guard let meal3 = Meal(name: "Fries", photo: photo3, rating: 3) else {
//      fatalError("Unable to instantiate meal2")
//    }
//
//    guard let meal4 = Meal(name: "Funnel Cake", photo: photo4, rating: 4) else {
//      fatalError("Unable to instantiate meal4")
//    }
//
//    guard let meal5 = Meal(name: "Margarita", photo: photo5, rating: 2) else {
//      fatalError("Unable to instantiate meal5")
//    }
//
//    guard let meal6 = Meal(name: "Pizza", photo: photo6, rating: 1) else {
//      fatalError("Unable to instantiate meal6")
//    }
    
    meals += [meal1, meal2]
  }

  private func saveMeals() {
    let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
    //This logs a debug message to the console if the save succeeds, and an error message to the console if the save fails.
    if isSuccessfulSave {
      os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
    } else {
      os_log("Failed to save meals...", log: OSLog.default, type: .error)
    }
  }
  
  private func loadMeals() -> [Meal]? {
    ///This method attempts to unarchive the object stored at the path Meal.ArchiveURL.path and downcast that object to an array of Meal objects. This code uses the as? operator so that it can return nil if the downcast fails. This failure typically happens because an array has not yet been saved. In this case, the unarchiveObject(withFile:) method returns nil. The attempt to downcast nil to [Meal] also fails, itself returning nil.
    return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
  }
  
}
