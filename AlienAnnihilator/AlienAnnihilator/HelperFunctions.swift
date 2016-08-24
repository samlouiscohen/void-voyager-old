//
//  HelperFunctions.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/23/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit



func normalizeVector(vector:CGVector) -> CGVector{
    let len = sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
    
    return CGVector(dx:vector.dx / len, dy:vector.dy / len)
}


func random(min:UInt32, max:UInt32) -> CGFloat{
    return CGFloat(arc4random_uniform(max - min) + min)
    //return CGFloat(arc4random_uniform(2))*(max-min) + min
}