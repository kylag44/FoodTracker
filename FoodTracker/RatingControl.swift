//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Kyla  on 2018-09-07.
//  Copyright © 2018 Kyla . All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
  
//MARK: Properties
  ///first is a property that contains the list of buttons. You don’t want to let anything outside the RatingControl class access these buttons; therefore, you declare them as private.
  private var ratingButtons = [UIButton]()
  ///  The Second property contains the control’s rating. You need to be able to both read and write this value from outside this class. By leaving it as internal access (the default), you can access it from any other class inside the app.
  @IBInspectable var rating = 0 {
    didSet {
      updateButtonSelectionStates()
    }
  }
  //These lines define the size of your buttons and the number of buttons in your control.
  @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
    didSet {
      setupButtons()
    }
  }
  @IBInspectable var starCount: Int = 5 {
    didSet {
      setupButtons()
    }
  }

//MARK: Initialization
  override init(frame: CGRect) {
   ///call the superclass’s initializer
    super.init(frame: frame)
  ///add the setuptbuttons method
    setupButtons()
  }
  
  required init(coder: NSCoder) {
    ////calls superclasses initializer 
    super.init(coder: coder)
    ///add the setuptbuttons method
    setupButtons()
  }
  
  //MARK: Button Action
  @objc func ratingButtonTapped(button: UIButton) {
    guard let index = ratingButtons.index(of: button) else {
      fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
    }
    
    // Calculate the rating of the selected button
    let selectedRating = index + 1
    
    if selectedRating == rating {
      // If the selected star represents the current rating, reset the rating to 0.
      rating = 0
    } else {
      // Otherwise set the rating to the selected star
      rating = selectedRating
    }
  }
  
///At this point, you’ve got the basics of a custom UIStackView subclass, called RatingControl. Next, you need to add buttons to your view to allow the user to select a rating. Start with something simple, like getting a single red button to show up in your view.
  //MARK: Private Methods
  private func setupButtons() {
    
    // clear any existing buttons
    for button in ratingButtons {
      removeArrangedSubview(button)
      button.removeFromSuperview()
    }
    ratingButtons.removeAll()
    
    // Load Button Images
    let bundle = Bundle(for: type(of: self))
    let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
    let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
    let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)

    ///To create a total of five buttons, use a for-in loop. The half-open range operator (..<) doesn’t include the upper number, so this range goes from 0 to 4 for a total of five loop iterations, drawing five buttons instead of just one. The underscore (_) represents a wildcard, which you can use when you don’t need to know which iteration of the loop is currently executing.
    for index in 0..<starCount {
    
    // Create the button
    let button = UIButton()
    // Set the button images///Buttons have five different states: normal, highlighted, focused, selected, and disabled. By default, the button modifies its appearance based on its state, for example a disabled button appears grayed out. A button can be in more than one state at the same time, such as when a button is both disabled and highlighted.
      button.setImage(emptyStar, for: .normal)
      button.setImage(filledStar, for: .selected)
      button.setImage(highlightedStar, for: .highlighted)
      button.setImage(highlightedStar, for: [.highlighted, .selected])
    
    // Add constraints
    button.translatesAutoresizingMaskIntoConstraints = false
    button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
    button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
      
    // Set the accessibility label
      button.accessibilityLabel = "Set \(index + 1) star rating"
    
    // Setup the button action/// i also fixed the error by letting it add objc to this
    button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
    
    // Add the button to the stack
    addArrangedSubview(button)
    // Add the new button to the rating button array
    ratingButtons.append(button)
  }
    updateButtonSelectionStates()
}
 
  private func updateButtonSelectionStates() {
    for (index, button) in ratingButtons.enumerated() {
      // If the index of a button is less than the rating, that button should be selected.
      button.isSelected = index < rating
      // Set the hint string for the currently selected star
      let hintString: String?
      if rating == index + 1 {
        hintString = "Tap to reset the rating to zero."
      } else {
        hintString = nil
      }
      
      // Calculate the value string
      let valueString: String
      switch (rating) {
      case 0:
        valueString = "No rating set."
      case 1:
        valueString = "1 star set."
      default:
        valueString = "\(rating) stars set."
      }
      
      // Assign the hint string and value string
      button.accessibilityHint = hintString
      button.accessibilityValue = valueString
    }
  }
  
}
