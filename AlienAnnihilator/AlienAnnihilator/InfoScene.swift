//
//  infoScene.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 9/25/16.
//  Copyright © 2016 SamuelStudios. All rights reserved.
//

import Foundation
import SpriteKit



class InfoScene: SKScene{
    override init(size: CGSize){
        super.init(size: size)
    }
    
    
    
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        
        let gobackButton = UIButton(frame: CGRect(x:size.width*0.9,y:size.height*0.8,width: size.width*0.1,height: size.height*0.1) )
        gobackButton.backgroundColor = SKColor.red
        gobackButton.setTitle("Back", for: UIControlState())
        gobackButton.setTitleColor(SKColor.black, for: UIControlState())
        gobackButton.layer.cornerRadius = 10
        gobackButton.layer.borderWidth = 2
        gobackButton.layer.borderColor = UIColor.darkGray.cgColor
        gobackButton.showsTouchWhenHighlighted = true
        gobackButton.addTarget(self, action: #selector(openStartScene), for: .touchUpInside)
        self.view?.addSubview(gobackButton)
        
        
        let titleLabel = instructText("Contact Info", fontSize: 30, color: SKColor.red, posMultiplier: CGPoint(x:0.5,y:0.9))
        
        titleLabel.position.x = size.width/2
        titleLabel.position.y = size.height*0.9
        
        addChild(titleLabel)
        
        let labelGoal0 = instructText("",
                                      fontSize: 20, color: SKColor.red, posMultiplier: CGPoint(x: 0.1,y: 0.8))
        labelGoal0.position.x = labelGoal0.frame.width/2 + size.width*0.05
        labelGoal0.position.y = size.height*0.75
        addChild(labelGoal0)
        
        
        let labelGoal1 = instructText("Feel free to leave feedback and/or bug sightings on the Facebook Page:",
                                      fontSize: 15, color: SKColor.red, posMultiplier: CGPoint(x: 0.5,y: 0.75))
        labelGoal1.position.x = size.width/2
        labelGoal1.position.y = labelGoal0.position.y - labelGoal1.frame.height*1.1
        addChild(labelGoal1)
        
        
        
        let labelGoal4 = instructText("https://www.facebook.com/voidvoyager/",
                                      fontSize: 15, color: SKColor.red, posMultiplier: CGPoint(x: 0.5,y: 0.6))
        labelGoal4.position.x = size.width/2
        labelGoal4.position.y = labelGoal1.position.y - labelGoal4.frame.height*1.5
        addChild(labelGoal4)
        
        let labelGoal5 = instructText("Designed and programmed by: Sam Cohen",
                                      fontSize: 15, color: SKColor.red, posMultiplier: CGPoint(x: 0.5,y: 0.6))
        labelGoal5.position.x = labelGoal5.frame.width/2 + size.width*0.1
        labelGoal5.position.y = labelGoal4.position.y - labelGoal5.frame.height*1.1
        //addChild(labelGoal5)

        
        
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
                self.view!.presentScene(startScene, transition: SKTransition.doorway(withDuration: 0.5))//, transition: SKTransition .doorway(withDuration: 0.5))
            }
        )
    }
    
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
}
