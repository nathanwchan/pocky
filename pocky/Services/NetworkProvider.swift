//
//  NetworkProvider.swift
//  pocky
//
//  Created by Nathan Chan on 8/29/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NetworkProvider: Network {
    var ref: DatabaseReference! = Database.database().reference()
    
    func getAllDishes(for userID: String, completion: @escaping ([Dish]?) -> Void) {
        ref.child("dishes").child("0").observe(.value, with: { (snapshot) in
            let data = snapshot.value as? [AnyObject]
            completion(data?.flatMap { Dish(data: $0) })
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
