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
        
       backgroundColor = SKColor.black
        
        
        let gobackButton = UIButton(frame: CGRect(x:size.width*0.9,y:size.height*0.8,width: size.width*0.1,height: size.height*0.1) )
        gobackButton.backgroundColor = SKColor.blue
        gobackButton.setTitle("Back", for: UIControlState())
        gobackButton.setTitleColor(SKColor.black, for: UIControlState())
        gobackButton.layer.cornerRadius = 10
        gobackButton.layer.borderWidth = 2
        gobackButton.layer.borderColor = UIColor.darkGray.cgColor
        gobackButton.showsTouchWhenHighlighted = true
        gobackButton.addTarget(self, action: #selector(openStartScene), for: .touchUpInside)
        self.view?.addSubview(gobackButton)
        
        
        let titleLabel = instructText("GAME INSTRUCTIONS", fontSize: 30, color: SKColor.red, posMultiplier: CGPoint(x:0.5,y:0.9))
        
        titleLabel.position.x = size.width/2
        titleLabel.position.y = size.height*0.9
        
        addChild(titleLabel)
        
        let labelGoal0 = instructText("Objective:",
                                  fontSize: 20, color: SKColor.red, posMultiplier: CGPoint(x: 0.1,y: 0.8))
        labelGoal0.position.x = labelGoal0.frame.width/2 + size.width*0.05
        labelGoal0.position.y = size.height*0.75
        addChild(labelGoal0)
        
        
        let labelGoal1 = instructText("Kill Aliens for as long as you can.",
                     fontSize: 15, color: SKColor.red, posMultiplier: CGPoint(x: 0.2,y: 0.75))
        labelGoal1.position.x = labelGoal1.frame.width/2 + size.width*0.1
        labelGoal1.position.y = labelGoal0.position.y - labelGoal1.frame.height*1.1
        addChild(labelGoal1)
        
        let labelGoal2 = instructText("A boss attacks in 40-60 second intervals.",
                                      fontSize: 15, color: SKColor.red, posMultiplier: CGPoint(x: 0.5,y: 0.6))
        labelGoal2.position.x = labelGoal2.frame.width/2 + size.width*0.1
        labelGoal2.position.y = labelGoal1.position.y - labelGoal2.frame.height*1.15
        addChild(labelGoal2)
        
        let labelGoal3 = instructText("A power up is spawned for every 60 killed aliens.",
                                      fontSize: 15, color: SKColor.red, posMultiplier: CGPoint(x: 0.5,y: 0.6))
        labelGoal3.position.x = labelGoal3.frame.width/2 + size.width*0.1
        labelGoal3.position.y = labelGoal2.position.y - labelGoal3.frame.height*1.1
        addChild(labelGoal3)
        
        
        let labelGoal4 = instructText("Take advantage of a malleable space-time to teleport.",
                                  fontSize: 15, color: SKColor.red, posMultiplier: CGPoint(x: 0.5,y: 0.6))
        labelGoal4.position.x = labelGoal4.frame.width/2 + size.width*0.1
        labelGoal4.position.y = labelGoal3.position.y - labelGoal4.frame.height*1.1
        addChild(labelGoal4)
        
        let labelGoal5 = instructText("You got three lives, make em' count.",
                                      fontSize: 15, color: SKColor.red, posMultiplier: CGPoint(x: 0.5,y: 0.6))
        labelGoal5.position.x = labelGoal5.frame.width/2 + size.width*0.1
        labelGoal5.position.y = labelGoal4.position.y - labelGoal5.frame.height*1.1
        addChild(labelGoal5)
        
        let tipsLabel = instructText("Tips:", fontSize: 20, color: SKColor.blue, posMultiplier: CGPoint(x:0.5, y:0.30))
        addChild(tipsLabel)
        
        let tip0Label = instructText("- Continuously move: try to never lift your finger from the virtual joystick.", fontSize: 10, color: SKColor.blue, posMultiplier: CGPoint(x:0.5, y:0.23))
        let tip1Label = instructText("- The joystick is VERY sensitive, you dont need to move your finger off of it", fontSize: 10, color: SKColor.blue, posMultiplier: CGPoint(x:0.5, y:0.17))
        let tip2Label = instructText("- Be cautious of the sceen edges as aliens spawn from them (Except the bottom edge)", fontSize: 10, color: SKColor.blue, posMultiplier: CGPoint(x:0.5, y:0.11))
        let tip3Label = instructText("- Play your music while you play!", fontSize: 10, color: SKColor.blue, posMultiplier: CGPoint(x:0.5, y:0.05))
        

        addChild(tip0Label)
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
