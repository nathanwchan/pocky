//
//  pockyTests.swift
//  pockyTests
//
//  Created by Nathan Chan on 8/19/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import XCTest
@testable import pocky

class pockyTests: XCTestCase {
    typealias Category = pocky.Category
    static let testNetworkProvider = TestNetworkProvider()
    var testMealsViewModel = MealsViewModel(networkProvider: testNetworkProvider)
//    var testMealPlansViewModel = MealPlansViewModel(networkProvider: testNetworkProvider)
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMealsVMGetDishCombos() {
        let categoryTests: [[Category]] = [
            Category.allValuesUsedForPlanning,
            Category.allValuesUsedForPlanning,
            Category.allValuesUsedForPlanning,
            [Category.Meat],
            [Category.Veggie],
            [Category.Carb],
            [Category.Meat, Category.Veggie],
            [Category.Meat, Category.Carb],
            [Category.Veggie, Category.Carb]
        ]
        for categories in categoryTests {
            let returnedDishes = testMealsViewModel.getDishCombos(with: categories)
            let returnedDishesCategories = returnedDishes.flatMap { $0.category }
            XCTAssertTrue(returnedDishesCategories.count == categories.count, "categories count should be equal")
            XCTAssertTrue(Set(returnedDishesCategories) == Set(categories), "categories values should be equal")
        }
    }
    
    func testMealsVMAddMealAndClearMeals() {
        let initMealCount = testMealsViewModel.mealCount
        
        for i in 1..<5 {
            testMealsViewModel.addNewMeal()
            XCTAssert(initMealCount + i == testMealsViewModel.mealCount, "addNewMeal did not add new meal")
        }
        
        testMealsViewModel.clearAllMeals()
        XCTAssert(testMealsViewModel.mealCount == 0, "clearAllMeals did not clear meals")
    }
    
    func testMealsVMShuffleDishes() {
        for _ in 0..<10 {
            testMealsViewModel.addNewMeal()
            XCTAssertTrue(testMealsViewModel.mealCount == 1)
            
            // test shuffling first dish in meal
            let firstDish = testMealsViewModel.meals[0].sortedDishes[0]
            testMealsViewModel.shuffleDishes(mealIndex: 0, categories: firstDish.category)
            
            let newDishes = testMealsViewModel.meals[0].dishes
            let newDishesCategories = newDishes.flatMap { $0.category }
            XCTAssertTrue((Set(newDishesCategories) == Set(Category.allValuesUsedForPlanning)), "missing categories after shuffle")
            XCTAssertTrue(newDishesCategories.count == Category.allValuesUsedForPlanning.count, "duplicate categories found after shuffle")
            XCTAssertTrue(!newDishes.contains(firstDish))
            
            testMealsViewModel.clearAllMeals()
            XCTAssertTrue(testMealsViewModel.mealCount == 0)
        }
    }
}
