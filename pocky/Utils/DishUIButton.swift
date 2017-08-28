//
//  DishUIButton.swift
//  pocky
//
//  Created by Nathan Chan on 8/27/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

class DishUIButton: UIButton {
    let dish: Dish
    let mealNumber: Int
    
    required init(dish: Dish, mealNumber: Int) {
        self.dish = dish
        self.mealNumber = mealNumber
        
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
