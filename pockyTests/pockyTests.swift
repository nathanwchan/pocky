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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMealsVMGetDishCombos() {
        let testMealsViewModel = MealsViewModel(networkProvider: TestNetworkProvider())
        let categoryTests: [[Category]] = [
            Category.allValues,
            Category.allValues,
            Category.allValues,
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
}
