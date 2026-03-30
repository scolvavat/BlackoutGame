//
//  HurtBox.swift
//  Blackout
//
//  Created by Michael Marion on 1/28/26.
//

internal import SpriteKit


class HurtBox: SKNode {
    init(size: CGSize) {
        super.init()
//        let texture = SKTexture(imageNamed: "bossMan")
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = Physics.hurtBox
        physicsBody?.contactTestBitMask = Physics.hitBox
    }
    required init?(coder: NSCoder) { fatalError()}
}


