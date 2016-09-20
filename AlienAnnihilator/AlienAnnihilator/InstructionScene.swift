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
    
    
    
    
    
    override func didMove(to view: SKView) {
        
       backgroundColor = SKColor.lightGray
        
        
        let gobackButton = UIButton(frame: CGRect(x:size.width*0.9,y:size.height*0.8,width: size.width*0.1,height: size.height*0.1) )
        gobackButton.backgroundColor = SKColor.green
        gobackButton.setTitle("Back", for: UIControlState())
        gobackButton.addTarget(self, action: #selector(openStartScene), for: .touchUpInside)
        self.view?.addSubview(gobackButton)
        
        
        let titleLabel = instructText("GAME INSTRUCTIONS", fontSize: 30, color: SKColor.red, posMultiplier: CGPoint(x:0.5,y:0.8))
        
        addChild(titleLabel)
        
        let label1 = instructText("Kill Aliens for as long as you can.",
                     fontSize: 15, color: SKColor.red, posMultiplier: CGPoint(x: 0.5,y: 0.7))
        
        addChild(label1)
        
        let label2 = instructText("You got three lives, make em' count.",
                                  fontSize: 15, color: SKColor.red, posMultiplier: CGPoint(x: 0.5,y: 0.6))
        
        addChild(label2)
        
        let tipsLabel = instructText("Tips:", fontSize: 20, color: SKColor.blue, posMultiplier: CGPoint(x:0.5, y:0.32))
        addChild(tipsLabel)
        
        let tip1Label = instructText("- Continuously move: try to never lift your finger from the virtual joystick.", fontSize: 10, color: SKColor.blue, posMultiplier: CGPoint(x:0.5, y:0.25))
        let tip2Label = instructText("- Be cautious of the sceen edges as aliens spawn from them (Except the bottom edge!)", fontSize: 10, color: SKColor.blue, posMultiplier: CGPoint(x:0.5, y:0.2))
        let tip3Label = instructText("- Every thirty seconds a powerup spawns, try and time it up with a boss level.", fontSize: 10, color: SKColor.blue, posMultiplier: CGPoint(x:0.5, y:0.15))
        
        
        
        addChild(tip1Label)
        addChild(tip2Label)
        addChild(tip3Label)

        
        
        
    }
    
    
    
    func instructText(_ text:String,fontSize:CGFloat,color:SKColor, posMultiplier:CGPoint) -> SKLabelNode{
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = text
        label.fontSize = fontSize
        label.fontColor = color
        label.position = CGPoint(x: size.width * posMultiplier.x, y: size.height * posMultiplier.y)
        
        return label
    }
    
    

    
    func openStartScene(_ sender:UIButton){
        print("Go back to start scene")
        sender.removeFromSuperview()
        buildStartScene()
    }
    
    
    func buildStartScene(){
        run(
            SKAction.run() {
                //Make a new gameScene
                let startScene:StartScene = StartScene(size: self.view!.bounds.size)
                startScene.scaleMode = SKSceneScaleMode.fill
                //Present it with a transition
                self.view!.presentScene(startScene, transition: SKTransition.doorway(withDuration: 0.5))
                }
            )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    
    
    
    
    
    
    
    
}
