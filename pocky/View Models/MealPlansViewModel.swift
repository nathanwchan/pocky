//
//  MealPlansViewModel.swift
//  pocky
//
//  Created by Nathan Chan on 8/31/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

class MealPlansViewModel {
    //MARK: - Properties
    private(set) var mealPlans = [MealPlan]()
    let networkProvider: Network!
    
    init(networkProvider: Network) {
        self.networkProvider = networkProvider
    }
    
    //MARK: - Events
    var didGetSavedMealPlans: ((MealPlansViewModel) -> Void)?
    
    //MARK: - Private
    private func didGetSavedMealPlans(mealPlans: [MealPlan]?) {
        self.mealPlans = mealPlans ?? []
        self.didGetSavedMealPlans?(self)
    }
    
    //MARK: - Actions
    func getSavedMealPlans() {
        networkProvider.getSavedMealPlans(completion: self.didGetSavedMealPlans)
    }
}
