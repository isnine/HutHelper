//
//  Extension + Const.swift
//  HutHelper
//
//  Created by 张驰 on 2019/11/19.
//  Copyright © 2019 nine. All rights reserved.
//

import Foundation
public extension Array {
    
    /**
     Returns a random element from the array. Can be used to create a playful
     message that cycles randomly through a set of emoji icons, for example.
     */
    public func sm_random() -> Iterator.Element? {
        guard count > 0 else { return nil }
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
}
