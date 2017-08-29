//
//  MealsViewModel.swift
//  pocky
//
//  Created by Nathan Chan on 8/22/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

class MealsViewModel {
    //MARK: - Properties
    private(set) var meals = [Meal]()
    var mealCount: Int {
        return meals.count
    }
    private(set) var allDishes: [Dish]?
    
    init(networkProvider: Network) {
        networkProvider.getAllDishes(for: "0", completion: self.didGetAllDishes)
    }
    
    //MARK: - Events
    var didAddNewMeal: ((MealsViewModel) -> Void)?
    var didClearAllMeals: ((MealsViewModel) -> Void)?
    var didShuffleDishes: ((MealsViewModel, Int) -> Void)?
    func didGetAllDishes(dishes: [Dish]?) {
        self.allDishes = dishes
        self.addNewMeal()
    }
    
    //MARK: - Private
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
        meals.append(Meal(mealIndex: self.mealCount,
                          dishes: getDishCombos(with: Category.allValues)))
        self.didAddNewMeal?(self)
    }
    
    func clearAllMeals() {
        meals = []
        self.didClearAllMeals?(self)
    }
    
    func shuffleDishes(mealIndex: Int, categories: [Category]) {
        let newDishes = getDishCombos(with: categories)
        
        if mealIndex < 0 || mealIndex >= meals.count {
            return
        }
        
        let dishesToKeep = meals[mealIndex].dishes.filter { Set($0.category).intersection(Set(categories)).isEmpty }
        meals[mealIndex].dishes = dishesToKeep + newDishes
        
        self.didShuffleDishes?(self, mealIndex)
    }
}
