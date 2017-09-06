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
    
    func deleteMealPlan(mealPlanId: String) {
        ref.child("mealPlans").child(Constants.globalUserID).child(mealPlanId).removeValue()
    }
    
    func getSavedMealPlans(completion: @escaping ([MealPlan]?) -> Void) {
        ref.child("mealPlans").child(Constants.globalUserID).observe(.value, with: { (snapshot) in
            var mealPlans = [MealPlan]()
            let mealPlansDispatchGroup = DispatchGroup()
            
            for snap in snapshot.children {
                let mealPlanSnap = snap as! DataSnapshot
                guard let dict = mealPlanSnap.value as? [String: AnyObject] else { continue }
                guard let title = dict["title"] as? String else { continue }
                guard let meals = dict["meals"] as? [AnyObject] else { continue }
                
                mealPlansDispatchGroup.enter()
                
                var mealsForMealPlan = [Meal]()
                let mealsDispatchGroup = DispatchGroup()
                
                for meal in meals {
                    guard let meal = meal as? [String: AnyObject] else { continue }
                    guard let mealIndex = meal["mealIndex"] as? Int else { continue }
                    guard let dishIds = meal["dishIds"]?.allKeys as? [String] else { continue }
                    
                    mealsDispatchGroup.enter()
                    
                    var dishesForMeal = [Dish]()
                    let dishesDispatchGroup = DispatchGroup()
                    
                    for dishId in dishIds {
                        dishesDispatchGroup.enter()
                        self.getDish(id: dishId) { dish in
                            guard let dish = dish else {
                                dishesDispatchGroup.leave()
                                return
                            }
                            dishesForMeal.append(dish)
                            dishesDispatchGroup.leave()
                        }
                    }
                    
                    dishesDispatchGroup.notify(queue: .main) {
                        mealsForMealPlan.append(Meal(mealIndex: mealIndex, dishes: dishesForMeal))
                        mealsDispatchGroup.leave()
                    }
                }
                
                mealsDispatchGroup.notify(queue: .main) {
                    mealPlans.append(MealPlan(id: mealPlanSnap.key, title: title, meals: mealsForMealPlan))
                    mealPlansDispatchGroup.leave()
                }
            }
            
            mealPlansDispatchGroup.notify(queue: .main) {
                completion(mealPlans)
            }
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
    
    func updateDish(dish: Dish) {
        guard let dishId = dish.id else {
            return
        }
        ref.child("dishes").child(Constants.globalUserID).child(dishId).setValue(dish.encodeForFirebase())
    }
    
    func createDish(dish: Dish, completion: @escaping ((String) -> Void)) {
        ref.child("dishes").child(Constants.globalUserID).childByAutoId().setValue(dish.encodeForFirebase()) { (error, retRef) in
                completion(retRef.key)
        }
    }
}
