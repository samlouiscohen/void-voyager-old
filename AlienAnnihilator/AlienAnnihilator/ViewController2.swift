////
////  ViewController2.swift
////  AlienAnnihilator
////
////  Created by Sam Cohen on 8/24/16.
////  Copyright © 2016 GuacGetters. All rights reserved.
////
//
//import Foundation
//import GameKit
//
//class ViewController: UIViewController, GKGameCenterControllerDelegate {
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        authPlayer()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        //Dispose of any resources that can be recreated
//    }
//    
//    
//    
//    
//    
//    
//    func authPlayer(){
//        
//        let localPlayer = GKLocalPlayer.localPlayer()
//        //See if signed in or not
//        localPlayer.authenticateHandler = {
//            (view,error) in
//            
//            //If there is a view to work with
//            if view != nil {
//                self.presentedViewController(view!, animated:true, completion: nil)
//            }
//            
//            else{
//                print(GKLocalPlayer.localPlayer().authenticated)
//            }
//        }
//        
//        
//    }
//    
//    
//    
//    
//    
//    
//}