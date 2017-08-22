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
    private(set) var mealViewModels = [MealViewModel]()
    var mealCount: Int {
        return mealViewModels.count
    }
    
    //MARK: - Events
    var didAddNewMeal: ((MealsViewModel) -> Void)?
    var didClearAllMeals: ((MealsViewModel) -> Void)?
    
    //MARK: - Actions
    func addNewMeal() {
        mealViewModels.append(MealViewModel(mealNumber: self.mealCount + 1))
        self.didAddNewMeal?(self)
    }
    
    func clearAllMeals() {
        mealViewModels = []
        self.didClearAllMeals?(self)
    }
}
