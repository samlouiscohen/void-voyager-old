//
//  PhysicsBodyExtension.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 9/13/16.
//  Copyright © 2016 SamuelStudios. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode{
    func copyWithPhysicsBody()->SKSpriteNode
    {
        let node = self.copy() as! SKSpriteNode;
        node.physicsBody = self.physicsBody;
        return node;
    }
}