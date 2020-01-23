//
//  HelpScene.swift
//  drag10.2
//
//  Created by Taylor Kelly on 11/14/18.
//  Copyright © 2018 Taylor Kelly. All rights reserved.
//

import Foundation
import SpriteKit

class HelpScene: SKScene {
    
    var background = SKSpriteNode(imageNamed: "howToPlay")
    var red = SKSpriteNode(imageNamed: "Rstar1")
    var blue = SKSpriteNode(imageNamed: "Bstar1")
    var green = SKSpriteNode(imageNamed: "Gstar")
    var yellow = SKSpriteNode(imageNamed: "yellowstar1")
    
    override func didMove(to view: SKView)
    {
        backgroundColor = SKColor.black;
        background.size = self.frame.size
        background.position = CGPoint(x: 0, y: 0)
        self.addChild(background)
        
        blue.position = CGPoint(x: -24.632, y: 39.514)
        blue.size = CGSize(width: 130, height: 130)
        self.addChild(blue)
        
        red.position = CGPoint(x: -24.632, y: -58.175)
        red.size = CGSize(width: 130, height: 130)
        self.addChild(red)
        
        green.position = CGPoint(x: -24.632, y: -252.145)
        green.size = CGSize(width: 130, height: 130)
        self.addChild(green)
        
        yellow.position = CGPoint(x: -24.632, y: -156.817)
        yellow.size = CGSize(width: 130, height: 130)
        self.addChild(yellow)
        
        blue.run(SKAction.repeatForever(SKAction.rotate(byAngle: 5, duration: 1)))
        red.run(SKAction.repeatForever(SKAction.rotate(byAngle: 5, duration: 1)))
        green.run(SKAction.repeatForever(SKAction.rotate(byAngle: 5, duration: 1)))
        yellow.run(SKAction.repeatForever(SKAction.rotate(byAngle: 5, duration: 1)))
        
        
        
    }
    
    func stopSpinning() {
        
        red.removeAllActions()
        blue.removeAllActions()
        yellow.removeAllActions()
        green.removeAllActions()
    
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        stopSpinning()
        
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 0.5))
       
        
    }
    
}
