//
//  GameScene.swift
//  BlobbyVolley
//
//  Created by Andrew Haentjens on 22/04/2018.
//  Copyright © 2018 Andrew Haentjens. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    enum CollisionTypes: UInt32 {
        case Ball = 1
        case Edge = 2
    }
    
    var ball: SKShapeNode!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        createEdges()
        self.ball = createBall()
        self.addChild(ball)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let nodes = self.nodes(at: touchLocation)
        
        if let node = nodes.first {
            if node.name == "ball" {
                punt(ball, from: touchLocation)
            }
        }
    }
    
    /**
     Create the edges of the frame
     */
    private func createEdges() {
        
        let edges = SKPhysicsBody(edgeLoopFrom: frame)
        edges.categoryBitMask = CollisionTypes.Edge.rawValue
        edges.contactTestBitMask = CollisionTypes.Ball.rawValue
    
        physicsBody = edges
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = true
        physicsBody?.mass = 0
        physicsBody?.friction = 0
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        physicsBody?.restitution = 1
        
    }
    
    private func createBall() -> SKShapeNode {
        
        let ball = SKShapeNode(circleOfRadius: frame.height / 15)
        ball.name =  "ball"
        ball.fillColor = .lightGray
        ball.strokeColor = .black
        ball.zPosition = 1
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        
        /** Add physics to ball */
        ball.physicsBody = SKPhysicsBody(circleOfRadius: frame.height / 15)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.restitution = 0.8
        ball.physicsBody?.linearDamping = 0.6
        ball.physicsBody?.friction = 0.6
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.mass = 1.0
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.categoryBitMask = CollisionTypes.Ball.rawValue
        ball.physicsBody?.contactTestBitMask = CollisionTypes.Edge.rawValue
        
        return ball
    }

    private func punt(_ ball: SKShapeNode, from touch: CGPoint) {
        
        let puntVector = CGVector(dx: (ball.position.x - touch.x) * 40.0, dy: (ball.position.y - touch.y) * 40.0)
        ball.physicsBody?.applyImpulse(puntVector)
        
        print(ball.position.x)
        print(ball.position.y)
        print(puntVector)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    /**
     When there's any contact, we can check between which bodies and react accordingly
     */
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == CollisionTypes.Edge.rawValue &&
            contact.bodyB.categoryBitMask == CollisionTypes.Ball.rawValue) {
            
        }
    }
}
