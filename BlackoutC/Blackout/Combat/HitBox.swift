//
//  HitBox.swift
//  Blackout
//
//  Created by Michael Marion on 1/28/26.
//

internal import SpriteKit

class HitBox: SKSpriteNode {
    let damage: Int
    var owner: Fighter?
    
    init(size: CGSize, damage: Int, owner: Fighter) {
        let NewHitBoxSize = CGSize(width: size.width * 3, height: size.height * 2)
        self.damage = damage
        self.owner = owner
        super.init(texture: nil, color: .red.withAlphaComponent(0.4), size: NewHitBoxSize)
        setupPhysics(size: NewHitBoxSize)
    }
    
    func didHit(target: Fighter) {
        guard let attacker = owner else { return }
        if target === attacker { return }
        
        target.takeDamage(self.damage)
        
        if target.health <= 0 {
            target.state = .ko
        }
        
        print("\(attacker.name) hit \(target.name) for \(damage) damage! Health is now \(target.health)")
    }
    
    private func setupPhysics(size: CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = false
        
        self.physicsBody?.categoryBitMask = Physics.hitBox
        self.physicsBody?.contactTestBitMask = Physics.hurtBox
        self.physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
