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

        
        
        let titleLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        titleLabel.text = "SPACE SURVIVAL"
        titleLabel.fontSize = 60
        titleLabel.fontColor = SKColor.redColor()
        titleLabel.position = CGPoint(x: size.width/2, y: size.height*0.65)
        //To allow for clicks on the label itself
        titleLabel.userInteractionEnabled = false
        addChild(titleLabel)
        
        
        let creditsLabel = SKLabelNode(fontNamed: "AvenirNext-BoldItalic ")
        
        creditsLabel.text = "A Samuel Studios Production"
        creditsLabel.fontSize = 10
        creditsLabel.fontColor = SKColor.redColor()
        creditsLabel.position = CGPoint(x: size.width*0.12, y: size.height*0.025)

        addChild(creditsLabel)
        
        
        
        
        
        
        
        //Start button
        let startButton = UIButton(frame: CGRect(x:size.width*0.2,y:size.height*0.6,width: size.width*0.25,height:size.width*0.1) )
        startButton.center.x = self.view!.center.x * 0.5
        startButton.backgroundColor = SKColor.init(red: 0, green: 153/255, blue: 0, alpha: 1)
        
        startButton.layer.cornerRadius = 10
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.greenColor().CGColor
        startButton.setTitle("Enter the Void", forState: .Normal)
        startButton.setTitleColor(UIColor.blackColor(), forState: .Normal)

        startButton.addTarget(self, action: #selector(startGame), forControlEvents: .TouchUpInside)
        self.view?.addSubview(startButton)
        
        
        //Instruction button
        let instructButton = UIButton(frame: CGRect(x:size.width*0.8, y:size.height*0.6, width:size.width*0.25, height:size.width*0.1) )
        instructButton.center.x = self.view!.center.x * 2 * 0.75
        instructButton.backgroundColor = SKColor.init(red: 0, green: 153/255, blue: 0, alpha: 1)
        instructButton.layer.cornerRadius = 10
        instructButton.layer.borderWidth = 1
        instructButton.layer.borderColor = UIColor.greenColor().CGColor
        instructButton.setTitle("Instructions", forState: .Normal)
        instructButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        instructButton.showsTouchWhenHighlighted = true
        instructButton.addTarget(self, action: #selector(startInstruction), forControlEvents: .TouchUpInside)
        self.view?.addSubview(instructButton)

        //Color change animation
        startButton.addTarget(self, action: #selector(holdRelease), forControlEvents: UIControlEvents.TouchUpInside);
        startButton.addTarget(self, action: #selector(holdDown), forControlEvents: UIControlEvents.TouchDown)
        instructButton.addTarget(self, action: #selector(holdRelease), forControlEvents: UIControlEvents.TouchUpInside);
        instructButton.addTarget(self, action: #selector(holdDown), forControlEvents: UIControlEvents.TouchDown)

        
        
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
    
    //target functions
    
    func buttonAnimation(sender:UIButton){
        
        holdDown(sender)
        holdRelease(sender)
    }
    
    
    func holdDown(sender:UIButton)
    {
        sender.backgroundColor = SKColor.init(red: 0, green: 102/255, blue: 0, alpha: 1)
    }
    
    func holdRelease(sender:UIButton)
    {
        sender.backgroundColor = SKColor.init(red: 0, green: 102/255, blue: 0, alpha: 1)
    }
    
    
    
    
    
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
                self.view!.presentScene(gameScene, transition: SKTransition.crossFadeWithDuration(1))//fadeWithColor(UIColor.blackColor(), duration: 2))
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


