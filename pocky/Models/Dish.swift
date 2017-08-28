//
//  Dish.swift
//  pocky
//
//  Created by Nathan Chan on 8/20/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

struct Dish: Equatable {
    var title: String
    var category: [Category]
    var link: String?
    var notes: String?
    
    init(title: String, category: [Category], link: String?, notes: String?) {
        self.title = title
        self.category = category
        self.link = link
        self.notes = notes
    }
    
    init?(data: AnyObject) {
        guard let dict = data as? [String: AnyObject] else { return nil }
        guard let title = dict["title"] as? String else { return nil }
        guard let category = dict["category"] as? [String] else { return nil }
        
        self.title = title
        self.category = category.flatMap { Category(rawValue: $0) }
        self.link = dict["link"] as? String
        self.notes = dict["notes"] as? String
    }
    
    static let sortClosure: (Dish, Dish) -> Bool = { dish1, dish2 in
        return dish1.category.map({ Category.index(of: $0) }).min()! < dish2.category.map({ Category.index(of: $0) }).min()!
    }
    
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        return lhs.title == rhs.title
    }
}
