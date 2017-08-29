//
//  Network.swift
//  pocky
//
//  Created by Nathan Chan on 8/29/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

protocol Network {
    func getAllDishes(for userID: String, completion: @escaping (([Dish]?) -> Void))
}
