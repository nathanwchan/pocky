//
//  MealsViewModel.swift
//  pocky
//
//  Created by Nathan Chan on 8/22/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MealsViewModel {
    //MARK: - Properties
    private(set) var meals = [Meal]()
    var mealCount: Int {
        return meals.count
    }
    private(set) var allDishes: [Dish]?
    
    init() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("dishes").child("0").observe(.value, with: { (snapshot) in
            let data = snapshot.value as? [AnyObject]
            self.allDishes = data?.flatMap { Dish(data: $0) }
            self.addNewMeal()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Events
    var didAddNewMeal: ((MealsViewModel) -> Void)?
    var didClearAllMeals: ((MealsViewModel) -> Void)?
    
    //MARK: - Private
    func getRandomDishes() -> [Dish] {
        guard let allDishes = allDishes else {
            return []
        }
        var randomDishes = [Dish]()
        for _ in 0..<arc4random_uniform(3)+1 {
            randomDishes.append(allDishes.randomItem()!)
        }
        return randomDishes
    }
    
    func getDishCombos(with categories: [Category], dishCombos: [Dish] = []) -> [Dish] {
        if categories.isEmpty {
            return dishCombos
        }
        let filterClosure: (Dish) -> Bool = { dish in
            let isDishWithinRequiredCategories = Set(dish.category).isSubset(of: Set(categories))
            // allow Carb dish to be duplicated
            var isDishAlreadyAdded = false
            if !(dish.category.count == 1 && dish.category.first! == .Carb) {
                isDishAlreadyAdded = self.meals.flatMap({ $0.dishes }).contains(dish)
            }
            return isDishWithinRequiredCategories && !isDishAlreadyAdded
        }
        guard let dishToAdd = allDishes?.filter(filterClosure).randomItem() else {
            return dishCombos
        }
        return getDishCombos(with: categories.filter { !dishToAdd.category.contains($0) }, dishCombos: dishCombos + [dishToAdd])
        
    }
    
    //MARK: - Actions
    func addNewMeal() {
        meals.append(Meal(mealNumber: self.mealCount + 1,
                          dishes: getDishCombos(with: Category.allValues)))
        self.didAddNewMeal?(self)
    }
    
    func clearAllMeals() {
        meals = []
        self.didClearAllMeals?(self)
    }
}
