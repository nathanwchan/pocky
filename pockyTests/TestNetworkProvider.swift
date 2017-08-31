//
//  TestNetworkProvider.swift
//  pocky
//
//  Created by Nathan Chan on 8/29/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation
@testable import pocky

class TestNetworkProvider: Network {
    var dishesData: [Dish]?
    
    init() {
        guard let file = Bundle.init(for: type(of: self)).url(forResource: "dishes_data", withExtension: "json") else {
            fatalError("file dishes_data.json doesn't exist")
        }
        do {
            let fileData = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: fileData, options: [])
            let data = json as? [AnyObject]
            dishesData = data?.flatMap { Dish(data: $0) }
        } catch let error {
            print(error.localizedDescription)
        }
    }
        
    func getAllDishes(for userID: String, completion: @escaping ([Dish]?) -> Void) {
        completion(dishesData)
    }
}