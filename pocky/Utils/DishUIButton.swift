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
    let mealIndex: Int
    
    required init(dish: Dish, mealIndex: Int) {
        self.dish = dish
        self.mealIndex = mealIndex
        
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
