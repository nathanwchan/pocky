//
//  Network.swift
//  pocky
//
//  Created by Nathan Chan on 8/29/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

protocol Network {
    func getAllDishes(completion: @escaping (([Dish]?) -> Void))
    func saveMealPlan(title: String, meals: [Meal])
    func getSavedMealPlans(completion: @escaping (([MealPlan]?) -> Void))
}
