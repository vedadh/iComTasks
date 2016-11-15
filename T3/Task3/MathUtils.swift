//
//  MathUtils.swift
//  Locator
//
//  Created by Vedad Hasanagic on 11/11/16.
//  Copyright © 2016 VEdad H. All rights reserved.
//

import Foundation

extension Double {
    
    func radians() -> Double {
        return (M_PI * self / 180)
    }
    
    func degrees() -> Double {
        return self * 180 / M_PI
    }
}