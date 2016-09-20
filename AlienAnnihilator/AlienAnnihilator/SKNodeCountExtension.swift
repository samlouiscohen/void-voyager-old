//
//  SKNodeCountExtension.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 9/1/16.
//  Copyright © 2016 SamuelStudios. All rights reserved.
//

import Foundation
import SpriteKit


extension SKNode {
    func subtreeCount() -> Int {
        return children.reduce(1) { $0 + $1.subtreeCount() }
    }
}