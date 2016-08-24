//
//  PauseButton2.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/23/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//
//
import Foundation
import SpriteKit

class PauseButton2: SKSpriteNode {
    
    func loadPauseLabel() {
        
        // Way 1, reference to current scene but not to specific class
        
        guard let scene = scene else { return }
        // Scene property is optional and is nil until button is added to a Scene so add the guard check.
        
        
//        scene.someBool = true      // NOT WORKING
//        scene.someMethod()         // NOT WORKING
//        
//        let label = SKLabelNode(...
//            scene.addChild(label)      // WORKING
        
            // Way 2, use "as" to cast to specific scene (e.g GameScene) so you can call properties/methods on it. This is the same as passing GameScene in the init method.
            
        guard let gameScene = scene as? GameScene else { return }
        
        
        // Scene property is optional and is nil until button is added to a Scene so add the guard check.
        // The button must be added to the scene you are trying the as? cast with, in this example GameScene.
        
//        
//        gameScene.someBool = true      // WORKING
//        gameScene.someMethod()         // WORKING
//        
//        let label = SKLabelNode(...
//            gameScene.addChild(label)      // WORKING
    }
}

