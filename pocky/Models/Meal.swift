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
    var sortedDishes: [Dish] {
        // super custom code to make sure Meat dishes are always first, then Veggie, then Carb
        return dishes.sorted(by: Dish.sortClosure)
    }
    
    init(mealNumber: Int, dishes: [Dish]) {
        self.mealNumber = mealNumber
        self.dishes = dishes
    }
}
