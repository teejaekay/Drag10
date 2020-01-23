//
//  HomeScene.swift
//  drag10.2
//
//  Created by Taylor Kelly on 11/8/18.
//  Copyright © 2018 Taylor Kelly. All rights reserved.
//

import Foundation
import SpriteKit

class HomeScene: SKScene {
    
    let homeBackground = SKSpriteNode(imageNamed: "homeBackground")
    let playButton = SKSpriteNode()
    let helpButton = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
       
        self.backgroundColor = SKColor.black
        homeBackground.size = self.frame.size
        self.addChild(homeBackground)
        isHome = true
        
        playButton.size = CGSize(width: 178, height: 100)
        playButton.position = CGPoint(x: -193, y: -130)
        playButton.color = UIColor.yellow
        playButton.alpha = 0
        self.addChild(playButton)
        
        helpButton.size = CGSize(width: 178, height: 100)
        helpButton.position = CGPoint(x: -193, y: -291)
        helpButton.color = UIColor.blue
        helpButton.alpha = 0
        self.addChild(helpButton)
        
        
    }
    
  
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches
        {
            let touchLocation = touch.location(in: self)
            
            if playButton.contains(touchLocation)
            {
                goGameScene()
            }
            if helpButton.contains(touchLocation)
            {
                print("going to help scene!")
                goHelpScene()
            }
        }
        
       
        
    }
    func goHelpScene()
    {
        let helpScene = HelpScene(fileNamed: "HelpScene")
        helpScene?.scaleMode = .aspectFill
        self.view?.presentScene(helpScene!, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    
    
    
    func goGameScene()
    {
        isHome = false
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
    }
    
}
