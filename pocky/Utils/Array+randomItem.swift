//
//  Array+randomItem.swift
//  pocky
//
//  Created by Nathan Chan on 8/24/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
