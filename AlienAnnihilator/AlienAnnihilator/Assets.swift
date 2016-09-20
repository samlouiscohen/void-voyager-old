//
//  Assets.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 9/11/16.
//  Copyright © 2016 SamuelStudios. All rights reserved.
//

import Foundation
import SpriteKit

class Assets {
    static let sharedInstance = Assets()
    let sprites = SKTextureAtlas(named: "Sprites")
    
    func preloadAssets() {
        sprites.preload {
            print("Sprites preloaded")
        }
    }
}
