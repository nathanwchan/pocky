//
//  Dish.swift
//  pocky
//
//  Created by Nathan Chan on 8/20/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

struct Dish: Equatable {
    var id: String?
    var title: String
    var category: [Category]
    var link: String? = nil
    var notes: String? = nil
    
    init(id: String? = nil, title: String, category: [Category], link: String?, notes: String?) {
        self.id = id
        self.title = title
        self.category = category
        self.link = link.nilIfEmpty
        self.notes = notes.nilIfEmpty
    }
    
    init?(id: String? = nil, data: Any?) {
        guard let dict = data as? [String: AnyObject] else { return nil }
        guard let title = dict["title"] as? String else { return nil }
        guard let category = dict["category"] as? [String] else { return nil }
        
        self.id = id
        self.title = title
        self.category = category.flatMap { Category(rawValue: $0) }
        if let link = (dict["link"] as? String).nilIfEmpty {
            self.link = link
        }
        if let notes = (dict["notes"] as? String).nilIfEmpty {
            self.notes = notes
        }
    }
    
    static let sortClosure: (Dish, Dish) -> Bool = { dish1, dish2 in
        return dish1.category.map({ Category.index(of: $0) }).min()! < dish2.category.map({ Category.index(of: $0) }).min()!
    }
    
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        return lhs.title == rhs.title
    }
    
    // Codable in Swift 4 !!!
    func encodeForFirebase() -> [String: Any] {
        var returnDict: [String: Any] = [
            "title": title,
            "category": category.map { $0.rawValue }
        ]
        if let link = link.nilIfEmpty {
            returnDict["link"] = link
        }
        if let notes = notes.nilIfEmpty {
            returnDict["notes"] = notes
        }
        return returnDict
    }
}
