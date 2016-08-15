//
//  GameViewController.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 7/14/16.
//  Copyright (c) 2016 GuacGetters. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.multipleTouchEnabled = true;
    
        let scene = StartScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        //skView.showsPhysics = true
        
        
        //scene.size = skView.bounds.size //???Added becuase screen dimensions didnt make sense?

        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
        
        
        
        
        
        
        //Comment out bc this hurt performance - instead I'll be explicit on specifics
//        skView.ignoresSiblingOrder = false;
        
        
//        @objc @objc func doubleTapped(){
//            
//        }
//        
//        //Switch between mike trump and aliens
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
//        tap.numberOfTapsRequired = 2
//        view.addGestureRecognizer(tap)
        
        
        
        

    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
