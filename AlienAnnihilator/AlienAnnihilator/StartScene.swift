//
//  StartScene.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 8/3/16.
//  Copyright © 2016 GuacGetters. All rights reserved.
//

import Foundation
import SpriteKit


class StartScene: SKScene{
    override init(size: CGSize){
        super.init(size: size)
    }
    
    
    
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.blackColor()

        let startButton = UIButton(frame: CGRect(x:size.width*0.2,y:size.height*0.5,width: size.width*0.25,height:size.width*0.1) )
        startButton.center.x = self.view!.center.x * 0.5
        startButton.backgroundColor = SKColor.redColor()
        startButton.setTitle("Enter the Void", forState: .Normal)
        startButton.addTarget(self, action: #selector(startGame), forControlEvents: .TouchUpInside)
        
        self.view?.addSubview(startButton)
        
        
        let instructButton = UIButton(frame: CGRect(x:size.width*0.8, y:size.height*0.5, width:size.width*0.25, height:size.width*0.1) )
        instructButton.center.x = self.view!.center.x * 2 * 0.75
        instructButton.backgroundColor = SKColor.redColor()
        instructButton.setTitle("Instructions", forState: .Normal)
        instructButton.addTarget(self, action: #selector(startInstruction), forControlEvents: .TouchUpInside)
        self.view?.addSubview(instructButton)
        //Instructions
        
        
        
        
    }
    
    
//    @objc func createButton(bgColor:SKColor,dims:[Double],txtColor:SKColor,txt:String,target:CGFunction) -> UIButton{
//        
//        let button = UIButton(frame: CGRect(x:dims[0],y:dims[1],width: dims[2],height: dims[3]) )
//        button.backgroundColor = SKColor.blueColor()
//        button.setTitle(txt, forState: .Normal)
////        button.addTarget(self, action: "startGame", forControlEvents: .TouchUpInside)
//
//        button.addTarget(self, action: #selector(target), forControlEvents: .TouchUpInside)
//        
//        self.view?.addSubview(button)
//        
//        return button
//    }
    
    
    
    
    
    
    //Method to really just remove all previously onscreen buttons
    func removeSubViews(){
        
        for subview in (view?.subviews)!{
            subview.removeFromSuperview()
        }
    }
    
    
    
    func buildInstructionScreen(){
        runAction(
            SKAction.runBlock() {
                //Make a new gameScene
                let instructionScene:InstructionScene = InstructionScene(size: self.view!.bounds.size)
                instructionScene.scaleMode = SKSceneScaleMode.Fill
                //Present it with a transition
                self.view!.presentScene(instructionScene, transition: SKTransition.doorwayWithDuration(0.5))
            }
        )
    }
    
    
    
    
    func startInstruction(sender:UIButton){
        print("Open insrtuctions")
        removeSubViews()
        buildInstructionScreen()
    }
    
    
    
    
    func buildGameScene(){
        
        runAction(
            SKAction.runBlock() {
                //Make a new gameScene
                let gameScene:GameScene = GameScene(size: self.view!.bounds.size)
                gameScene.scaleMode = SKSceneScaleMode.Fill
                //Present it with a transition
                self.view!.presentScene(gameScene, transition: SKTransition.doorwayWithDuration(0.5))
            }
        )
    }
    
    
    
    
    
    func startGame(sender:UIButton!){
        print("Hi")
        
//        sender.removeFromSuperview()
        removeSubViews()
        buildGameScene()
        
        
        
    }

    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


