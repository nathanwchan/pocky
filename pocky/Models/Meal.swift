//
//  Meal.swift
//  pocky
//
//  Created by Nathan Chan on 8/23/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

struct Meal {
    var mealIndex: Int
    var dishes: [Dish]
    var sortedDishes: [Dish] {
        // super custom code to make sure Meat dishes are always first, then Veggie, then Carb
        return dishes.sorted(by: Dish.sortClosure)
    }
    
    init(mealIndex: Int, dishes: [Dish]) {
        self.mealIndex = mealIndex
        self.dishes = dishes
    }
    
    // Codable in Swift 4 !!!
    func encodeForFirebase() -> [String: Any] {
        let dishIds = dishes.compactMap { (dish) -> (String, Bool)? in
            guard let dishId = dish.id else {
                return nil
            }
            return (dishId, true)
        }
        return [
            "mealIndex": mealIndex,
            "dishIds": Dictionary(elements: dishIds)
        ]
    }
}
