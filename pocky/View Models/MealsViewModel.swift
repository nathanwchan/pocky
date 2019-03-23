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
    let networkProvider: Network!
    private var dishesViewModel: DishesViewModel!
    
    init(networkProvider: Network = NetworkProvider()) {
        self.networkProvider = networkProvider
        dishesViewModel = DishesViewModel(networkProvider: networkProvider)
        dishesViewModel?.didGetAllDishes = { [weak self] in
            self?.didInitViewModel?()
        }
    }
    
    //MARK: - Events
    var didInitViewModel: (() -> Void)?
    var didAddNewMeal: (() -> Void)?
    var didClearAllMeals: (() -> Void)?
    var didShuffleDishes: ((Int) -> Void)?
    var didLoadMealPlan: (() -> Void)?
    
    //MARK: - Private
    func getDishCombos(with categories: [Category], dishCombos: [Dish] = []) -> [Dish] {
        if categories.isEmpty {
            return dishCombos
        }
        
        guard let dishToAdd = dishesViewModel.getNewUnseenDish(with: categories) else {
            return dishCombos
        }
        return getDishCombos(with: categories.filter { !dishToAdd.category.contains($0) }, dishCombos: dishCombos + [dishToAdd])
        
    }
    
    //MARK: - Actions
    func addNewMeal() {
        meals.append(Meal(mealIndex: self.mealCount,
                          dishes: getDishCombos(with: Category.allValuesUsedForPlanning)))
        self.didAddNewMeal?()
    }
    
    func clearAllMeals() {
        meals = []
        self.didClearAllMeals?()
    }
    
    func shuffleDishes(mealIndex: Int, categories: [Category]) {
        let newDishes = getDishCombos(with: categories)
        
        if mealIndex < 0 || mealIndex >= meals.count {
            return
        }
        
        let dishesToKeep = meals[mealIndex].dishes.filter { Set($0.category).intersection(Set(categories)).isEmpty }
        meals[mealIndex].dishes = dishesToKeep + newDishes
        
        self.didShuffleDishes?(mealIndex)
    }
    
    func saveMealPlan(title: String) {
        let mealPlan = MealPlan(title: title, meals: meals)
        networkProvider.saveMealPlan(mealPlan: mealPlan)
    }
    
    func loadMealPlan(_ mealPlan: MealPlan) {
        meals = mealPlan.meals
        self.didLoadMealPlan?()
    }
}
