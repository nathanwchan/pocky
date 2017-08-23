//
//  Meal.swift
//  pocky
//
//  Created by Nathan Chan on 8/23/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

struct Meal {
    var mealNumber: Int
    var title: String {
        return "Meal \(mealNumber)"
    }
    var dishes: [Dish]
    
    init(mealNumber: Int, dishes: [Dish]) {
        self.mealNumber = mealNumber
        self.dishes = dishes
    }
}
