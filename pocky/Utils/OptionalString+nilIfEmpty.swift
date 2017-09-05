//
//  OptionalString+nilIfEmpty.swift
//  pocky
//
//  Created by Nathan Chan on 9/4/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let s = self else {
            return nil
        }
        return s.isEmpty ? nil : s
    }
}
