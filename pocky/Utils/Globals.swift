//
//  Globals.swift
//  pocky
//
//  Created by Nathan Chan on 8/20/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

enum Constants {
    // using enum so that it can't accidentally be instantiated and works purely as a namespace.
    static let globalUserID = "0"
}

enum Category: String {
    case Meat = "m"
    case Veggie = "v"
    case Carb = "c"
    case Dessert = "d"
    case Special = "s"
}

extension Category {
    // these are deliberately ordered for display
    static let allValuesUsedForPlanning = [Category.Meat, Category.Veggie, Category.Carb]
    static let allValues = [Category.Meat, Category.Veggie, Category.Carb, Category.Dessert, Category.Special]
    
    static func index(of category: Category) -> Int {
        return allValues.index(of: category) ?? allValues.count
    }
}
