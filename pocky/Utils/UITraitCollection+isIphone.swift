//
//  UITraitCollection+isIphone.swift
//  pocky
//
//  Created by Nathan Chan on 9/6/17.
//  Copyright © 2017 Nathan Chan. All rights reserved.
//

import UIKit

extension UITraitCollection {
    var isIphone: Bool {
        return horizontalSizeClass == .compact
    }
}
