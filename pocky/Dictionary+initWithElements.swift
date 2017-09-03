//
//  Dictionary+initWithElements.swift
//  pocky
//
//  Created by Nathan Chan on 9/1/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

extension Dictionary {
    init(elements:[(Key, Value)]) {
        self.init()
        for (key, value) in elements {
            updateValue(value, forKey: key)
        }
    }
}
