//
//  MealPlan.swift
//  pocky
//
//  Created by Nathan Chan on 8/31/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

struct MealPlan {
    var id: String?
    var title: String
    var meals: [Meal]
    
    init(id: String? = nil, title: String, meals: [Meal]) {
        self.id = id
        self.title = title
        self.meals = meals
    }
    
    init?(id: String, data: Any?) {
        guard let dict = data as? [String: AnyObject] else { return nil }
        guard let title = dict["title"] as? String else { return nil }
        
        self.id = id
        self.title = title
        self.meals = []
    }
    
    // Codable in Swift 4 !!!
    func encodeForFirebase() -> [String: Any] {
        return [
            "title": title,
            "meals": meals.map({ $0.encodeForFirebase() })
        ]
    }
}
