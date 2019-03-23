//
//  TestNetworkProvider.swift
//  pocky
//
//  Created by Nathan Chan on 8/29/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation
@testable import pocky

class TestNetworkProvider: Network {
    var dishes = [Dish]()
    var mealPlans = [MealPlan]()
    
    init() {
        guard let file = Bundle.init(for: type(of: self)).url(forResource: "pockyTestsData", withExtension: "json") else {
            fatalError("file pockyTestsData doesn't exist")
        }
        do {
            let fileData = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: fileData, options: [])
            let jsonData = json as? [String: AnyObject]
            
            guard let dishesJsonData = jsonData?["dishes"] as? [AnyObject] else {
                fatalError("dishes json data not available")
            }
            dishes = dishesJsonData.compactMap { Dish(data: $0) }
            
            guard let mealPlansOuterJsonData = jsonData?["mealPlans"] as? [AnyObject],
            let mealPlansJsonData = mealPlansOuterJsonData[0] as? [String: AnyObject] else {
                fatalError("meal plan json data not available")
            }
            mealPlans = mealPlansJsonData.compactMap { mealPlanJsonData -> MealPlan? in
                guard let mealPlanData = mealPlanJsonData.value as? [String: AnyObject] else {
                    return nil
                }
                guard let title = mealPlanData["title"] as? String else {
                    return nil
                }
                guard let mealsJsonData = mealPlanData["meals"] as? [String: AnyObject] else {
                    return nil
                }
                let meals = mealsJsonData.compactMap { mealJsonData -> Meal? in
                    let mealData = mealJsonData.value as? [String: AnyObject]
                    guard let mealIndex = mealData?["mealIndex"] as? Int else {
                        return nil
                    }
                    guard let dishIds = mealData?["dishIds"] as? [String: Bool] else {
                        return nil
                    }
                    var mealDishes = [Dish]()
                    for dishId in dishIds {
                        if let dish = self.dishes.filter({ $0.id == dishId.key }).first {
                            mealDishes.append(dish)
                        }
                    }
                    return Meal(mealIndex: mealIndex, dishes: mealDishes)
                }
                return MealPlan(id: mealPlanJsonData.key, title: title, meals: meals)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getAllDishes(completion: @escaping ([Dish]?) -> Void) {
        completion(dishes)
    }
 
    func saveMealPlan(mealPlan: MealPlan) {
        mealPlans.append(mealPlan)
    }
    
    func deleteMealPlan(mealPlanId: String) {
        mealPlans = mealPlans.filter { $0.id != mealPlanId }
    }
    
    func getSavedMealPlans(completion: @escaping (([MealPlan]?) -> Void)) {
        completion(mealPlans)
    }
    
    func getDish(id: String, completion: @escaping ((Dish?) -> Void)) {
        if let dish = self.dishes.filter({ $0.id == id }).first {
            completion(dish)
        }
    }
    
    func updateDish(dish: Dish) {
        guard let dishId = dish.id else {
            return
        }
        dishes = dishes.filter { $0.id != dishId }
        dishes.append(dish)
    }
    
    func createDish(dish: Dish, completion: @escaping ((String) -> Void)) {
        dishes.append(dish)
        completion("0")
    }
}
