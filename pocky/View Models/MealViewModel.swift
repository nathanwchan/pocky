//
//  MealViewModel.swift
//  pocky
//
//  Created by Nathan Chan on 8/22/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

class MealViewModel {
    var mealNumber: Int
    var title: String {
        return "Meal \(mealNumber)"
    }
    var dishes: [Dish]
//    private(set) var dishViewModels = [DishViewModel]
    
    let dishNames = ["Chicken pasta", "Honey garlic salmon", "Garlic a-cai", "Roasted asparagus", "White rice", "Roasted sweet potatoes"]
    
    init(mealNumber: Int) {
        self.mealNumber = mealNumber
        
        var generatedDishes: [Dish] = []
        for _ in 0..<arc4random_uniform(3)+1 {
            let dish = Dish(title: dishNames[Int(arc4random_uniform(UInt32(dishNames.count)))],
                            category: [[Category.Meat, Category.Veggie, Category.Carb][Int(arc4random_uniform(UInt32(3)))]],
                            link: "",
                            notes: "")
            generatedDishes.append(dish)
        }
        self.dishes = generatedDishes
    }
}
