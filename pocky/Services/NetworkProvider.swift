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
    
    func saveMealPlan(mealPlan: MealPlan) {
        ref.child("mealPlans").child(Constants.globalUserID).childByAutoId().setValue(mealPlan.encodeForFirebase())
    }
    
    func getSavedMealPlans(completion: @escaping ([MealPlan]?) -> Void) {
        ref.child("mealPlans").child(Constants.globalUserID).observe(.value, with: { (snapshot) in
            let mealPlans: [MealPlan] = snapshot.children.flatMap { snap in
                let mealPlanSnap = snap as! DataSnapshot
                return MealPlan(id: mealPlanSnap.key, data: mealPlanSnap.value)
            }
            completion(mealPlans)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getDish(id: String, completion: @escaping (Dish?) -> Void) {
        ref.child("dishes").child(Constants.globalUserID).child(id).observe(.value, with: { (snapshot) in
            let value = snapshot.value as? [String : AnyObject]
            let dish = Dish(id: snapshot.key, data: value)
            completion(dish)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func saveDish(dish: Dish) {
        ref.child("dishes").child(Constants.globalUserID).child(dish.id).setValue(dish.encodeForFirebase())
    }
}
