//
//  Globals.swift
//  pocky
//
//  Created by Nathan Chan on 8/20/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

enum Category: String {
    case Meat = "m"
    case Veggie = "v"
    case Carb = "c"
}

extension Category {
    static let allValues = [Category.Meat, Category.Veggie, Category.Carb]
}
