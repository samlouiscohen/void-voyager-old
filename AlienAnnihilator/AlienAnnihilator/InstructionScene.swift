//
//  InstructionScene.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/4/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit


class InstructionScene: SKScene{
    override init(size: CGSize){
        super.init(size: size)
    }
    
    
    
    
    
    override func didMoveToView(view: SKView) {
        
       backgroundColor = SKColor.lightGrayColor()
        
        
        let gobackButton = UIButton(frame: CGRect(x:size.width*0.9,y:size.height*0.8,width: size.width*0.1,height: size.height*0.1) )
        gobackButton.backgroundColor = SKColor.greenColor()
        gobackButton.setTitle("Back", forState: .Normal)
        gobackButton.addTarget(self, action: #selector(openStartScene), forControlEvents: .TouchUpInside)
        self.view?.addSubview(gobackButton)
        
        
        
        let instructLabel = SKLabelNode(fontNamed: "Chalkduster")
        instructLabel.text = "Here are some wild complicated instructions"
        instructLabel.fontSize = 20
        instructLabel.fontColor = SKColor.whiteColor()
        instructLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        //instructLabel.userInteractionEnabled = true
        addChild(instructLabel)
        
        
    }
    
    
    
    
    

    
    func openStartScene(sender:UIButton){
        print("Go back to start scene")
        sender.removeFromSuperview()
        buildStartScene()
    }
    
    
    func buildStartScene(){
        runAction(
            SKAction.runBlock() {
                //Make a new gameScene
                let startScene:StartScene = StartScene(size: self.view!.bounds.size)
                startScene.scaleMode = SKSceneScaleMode.Fill
                //Present it with a transition
                self.view!.presentScene(startScene, transition: SKTransition.doorwayWithDuration(0.5))
                }
            )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    
    
    
    
    
    
    
    
}
