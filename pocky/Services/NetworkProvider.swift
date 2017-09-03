//
//  NetworkProvider.swift
//  pocky
//
//  Created by Nathan Chan on 8/29/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NetworkProvider: Network {
    var ref: DatabaseReference! = Database.database().reference()
    
    func getAllDishes(completion: @escaping ([Dish]?) -> Void) {
        ref.child("dishes").child(Constants.globalUserID).observe(.value, with: { (snapshot) in
            let dishes: [Dish] = snapshot.children.flatMap { snap in
                let dishSnap = snap as! DataSnapshot
                return Dish(id: dishSnap.key, data: dishSnap.value)
            }
            completion(dishes)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func saveMealPlan(title: String, meals: [Meal]) {
        let mealPlan = MealPlan(title: title, meals: meals)
        self.ref.child("mealPlans").child(Constants.globalUserID).childByAutoId().setValue(mealPlan.encodeForFirebase())
    }
    
    func getSavedMealPlans(completion: @escaping ([MealPlan]?) -> Void) {
        ref.child("mealPlans").child(Constants.globalUserID).observe(.value, with: { (snapshot) in
            let mealPlans: [MealPlan] = snapshot.children.flatMap { snap in
                let mealPlanSnap = snap as! DataSnapshot
//                guard let dict = mealPlanSnap.value as? [String: AnyObject] else { return nil }
//                guard let title = dict["title"] as? String else { return nil }
//                guard let meals = dict["meals"] as? [AnyObject] else { return nil }
//                
//                meals.flatMap { meal in
//                    guard let meal = meal as? [String: AnyObject] else { return nil }
//                    guard let mealIndex = meal["mealIndex"] as? Int else { return nil }
//                    guard let dishIds = meal["dishIds"]?.allKeys as? [String] else { return nil }
//                    
//                    ref.child("dishes").child(Constants.globalUserID).observeSingleEvent(of: .value, with: { (snapshot) in
//                        let data = snapshot.value as? [AnyObject]
//                    }
//                    return meal
//                }
                
                return MealPlan(id: mealPlanSnap.key, data: mealPlanSnap.value)
            }
            completion(mealPlans)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
