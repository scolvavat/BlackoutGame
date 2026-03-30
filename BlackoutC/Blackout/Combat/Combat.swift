//
//  Combat.swift
//  Blackout
//
//  Created by Michael Marion on 2/3/26.
//

import SwiftUI

internal import SpriteKit

class Combat: SKSpriteNode {

    var stats: FighterStats
    var health: Int
    var state: FighterState = .idle

    var hurtBox: HurtBox!
    var activeHitBox: HitBox?

    init(textureName: String, stats: FighterStats) {
        self.stats = stats
        self.health = stats.maxHealth
        
        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: .clear, size: texture.size())
        self.anchorPoint = CGPoint( x: 0.5, y: 0)

        setupPhysics()
        setupHurtBox()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = Physics.fighter
        physicsBody?.collisionBitMask = Physics.background
        physicsBody?.contactTestBitMask = 0
    }

    private func setupHurtBox() {
        hurtBox = HurtBox(size: size)
        hurtBox.position = .zero
        addChild(hurtBox)
    }
}
