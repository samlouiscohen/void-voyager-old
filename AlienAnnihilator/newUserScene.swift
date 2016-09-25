//
//  newUserScene.swift
//  AlienAnnihilator
//
//  Created by Sam Cohen on 9/23/16.
//  Copyright © 2016 SamuelStudios. All rights reserved.
//

import Foundation
import SpriteKit


import Foundation
import SpriteKit


class NewUserScene: SKScene{
    
    override init(size: CGSize){
        super.init(size: size)
    }
    
    
    
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        let viewWidth = self.view!.bounds.maxX
        let viewHeight = self.view!.bounds.maxY
        
        //Preload textures
        Assets.sharedInstance.preloadAssets()
        
        let titleLabel = SKLabelNode(fontNamed: "Chalkduster")
        
        titleLabel.text = "VOID VOYAGER"
        titleLabel.fontSize = size.width*0.1//60
        titleLabel.fontColor = SKColor.red
        titleLabel.position = CGPoint(x: size.width/2, y: size.height*0.65)
        //To allow for clicks on the label itself
        titleLabel.isUserInteractionEnabled = false
        addChild(titleLabel)
        
        
        let creditsLabel = SKLabelNode(fontNamed: "AvenirNext-BoldItalic ")
        
        creditsLabel.text = "A Samuel Studios Production"
        creditsLabel.fontSize = 10
        creditsLabel.fontColor = SKColor.red
        creditsLabel.position = CGPoint(x: size.width*0.12, y: size.height*0.025)
        
        addChild(creditsLabel)
        
        
        
        
        
        
 
        
        
        //Training button
        let TrainingButton = UIButton(frame: CGRect(x:self.view!.center.x, y:self.view!.center.y, width:size.width*0.25, height:size.width*0.1) )
        TrainingButton.center.x = self.view!.center.x// * 2 * 0.75
        TrainingButton.center.y = self.view!.center.y*1.3// + instructButton.bounds.height*2*1.1// * 2 * 0.75
        TrainingButton.backgroundColor = SKColor.init(red: 0, green: 153/255, blue: 0, alpha: 1)
        TrainingButton.layer.cornerRadius = 10
        TrainingButton.layer.borderWidth = 1
        TrainingButton.layer.borderColor = UIColor.green.cgColor
        TrainingButton.setTitle("Training", for: UIControlState())
        TrainingButton.setTitleColor(UIColor.black, for: UIControlState())
        TrainingButton.showsTouchWhenHighlighted = true
        TrainingButton.addTarget(self, action: #selector(startDemo), for: .touchUpInside)
        self.view?.addSubview(TrainingButton)
        
        //Color change animation

        TrainingButton.addTarget(self, action: #selector(holdRelease), for: UIControlEvents.touchUpInside);
        TrainingButton.addTarget(self, action: #selector(holdDown), for: UIControlEvents.touchDown)
        
        
        
    }
    
    

    //target functions
    
    func buttonAnimation(_ sender:UIButton){
        
        holdDown(sender)
        holdRelease(sender)
    }
    
    
    func holdDown(_ sender:UIButton)
    {
        sender.backgroundColor = SKColor.init(red: 0, green: 102/255, blue: 0, alpha: 1)
    }
    
    func holdRelease(_ sender:UIButton)
    {
        sender.backgroundColor = SKColor.init(red: 0, green: 102/255, blue: 0, alpha: 1)
    }
    
    
    
    
    func buildDemoScene(){
        run(
            SKAction.run() {
                //Make a new gameScene
                let demoScene:DemoScene = DemoScene(size: self.view!.bounds.size)
                demoScene.scaleMode = SKSceneScaleMode.fill
                //Present it with a transition
                self.view!.presentScene(demoScene, transition: SKTransition.doorway(withDuration: 0.5))
            }
        )
    }
    
    func startDemo(_ sender:UIButton){
        print("Open insrtuctions")
        removeSubViews()
        buildDemoScene()
    }
    
    
    
    //Method to really just remove all previously onscreen buttons
    func removeSubViews(){
        
        for subview in (view?.subviews)!{
            subview.removeFromSuperview()
        }
    }
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


