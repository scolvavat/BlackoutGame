//
//  FighterState.swift
//  Blackout
//
//  Created by Michael Marion on 1/28/26.
//

internal import SpriteKit
import UIKit

enum FighterState {
    case idle, walking, attacking, ko, jumping, ducking, blocking
}

enum AttackType {
    case lowPunch, highPunch, lowKick, highKick
}

class Fighter: SKSpriteNode {
    
    // main state handling
    
    var state: FighterState = .idle {
        didSet {
            if oldValue != state {
                updateAnimation()
            }
        }
    }
    
    // combat
    
    var activeHitBox: HitBox?
    private(set) var hurtBox: HurtBox?
    
    var stats: FighterStats
    var characterName: String = ""
    
    // misc
    
    let container = SKSpriteNode(color: .black, size: CGSize(width: 200, height: 200))
    let mask = SKSpriteNode(color: .white, size: CGSize(width: 200, height: 200))
    
    var health: CGFloat = 100 {
        didSet {
            if health < 0 { health = 0 }
            if health > 100 { health = 100 }
        }
    }
    
    // init
    
    init(stats: FighterStats, name: String = "fighter") {
        self.stats = stats
        self.characterName = name
        
        let texture = SKTexture(imageNamed: "idle_1")
        let targetHeight: CGFloat = 750
        let aspectRatio = max(texture.size().width / max(texture.size().height, 1), 0.6)
        let targetWidth = targetHeight * aspectRatio
        
        super.init(
            texture: texture,
            color: .clear,
            size: CGSize(width: targetWidth, height: targetHeight)
        )
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(stats:name:) instead.")
    }
    
    // animation frame sources
    
    func idleFrameNames() -> [String] {
        switch characterName {
        case "BEEZY":
            return ["beezy1"]
        case "GROOVY":
            return ["groovyIdleOne", "groovyIdleTwo"]
        case "BIGGIE":
            return ["biggieIdleTwo", "biggieIdleThree", "biggieIdleFour"]
        case "WIGZ":
            return ["wigz"]
        case "SCAM MAN":
            return ["scamMan"]
        case "Boss Man":
            return ["bossMan"]
        default:
            return ["idle_1"]
        }
    }
    
    func walkFrameNames() -> [String] {
        switch characterName {
        case "BEEZY":
            return ["beezy1"]
        case "GROOVY":
            return ["groovyWalkOne", "groovyWalkTwo"]
        case "BIGGIE":
            return ["biggieWalk", "biggieWalkTwo"]
        case "WIGZ":
            return ["wigz"]
        case "SCAM MAN":
            return ["scamMan"]
        case "Boss Man":
            return ["bossMan"]
        default:
            return idleFrameNames()
        }
    }
    
    func makeTextures(from names: [String]) -> [SKTexture] {
        names.map { SKTexture(imageNamed: $0) }
    }
    
    // reversed character handling (fixes backwards sprites)
    
    func isReversedCharacter() -> Bool {
        switch characterName {
        case "BIGGIE", "Biggie",
             "GROOVY", "Groovy":
            return true
        default:
            return false
        }
    }
    
    // logical facing
    
    func isFacingRight() -> Bool {
        if isReversedCharacter() {
            return xScale < 0
        } else {
            return xScale >= 0
        }
    }
    
    func facingDirection() -> CGFloat {
        isFacingRight() ? 1 : -1
    }
    
    func faceLeft() {
        if isReversedCharacter() {
            xScale = 1
        } else {
            xScale = -1
        }
    }
    
    func faceRight() {
        if isReversedCharacter() {
            xScale = -1
        } else {
            xScale = 1
        }
    }
    
    // walking
    
    func walkanimation() {
        let textures = makeTextures(from: walkFrameNames())
        removeAction(forKey: "anim")
        state = .walking
        
        if let first = textures.first {
            texture = first
        }
        
        if textures.count > 1 {
            let action = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.12))
            run(action, withKey: "anim")
        }
    }
    
    func startWalking() {
        guard state == .idle || state == .walking else { return }
        
        if state != .walking || action(forKey: "anim") == nil {
            walkanimation()
        }
    }
    
    func stopWalking() {
        if state == .walking {
            state = .idle
        } else {
            removeAction(forKey: "anim")
            updateAnimation()
        }
    }
    
    // hurtbox
    
    func configureHurtBox() {
        hurtBox?.removeFromParent()
        
        let hbSize = CGSize(width: size.width * 0.35, height: size.height * 0.75)
        let hb = HurtBox(size: hbSize)
        hb.position = CGPoint(x: 0, y: size.height / 2)
        hb.name = "hurtBox_\(characterName)"
        addChild(hb)
        hurtBox = hb
    }
    
    // attack (FIXED hitbox direction)
    
    func attack(type: AttackType) {
        guard state == .idle || state == .ducking || state == .walking else { return }
        
        let previousState: FighterState = (state == .walking) ? .idle : state
        state = .attacking
        
        let size: CGSize
        let position: CGPoint
        
        switch type {
        case .lowPunch:
            size = CGSize(width: 100, height: 80)
            position = CGPoint(x: 120, y: 200)
        case .highPunch:
            size = CGSize(width: 120, height: 100)
            position = CGPoint(x: 140, y: 450)
        case .highKick:
            size = CGSize(width: 150, height: 100)
            position = CGPoint(x: 160, y: 500)
        case .lowKick:
            size = CGSize(width: 130, height: 80)
            position = CGPoint(x: 130, y: 100)
        }
        
        let hitBox = HitBox(size: size, damage: stats.attack, owner: self)
        hitBox.isHidden = true
        
        // fix: flip hitbox with logical direction
        let direction = facingDirection()
        hitBox.position = CGPoint(
            x: position.x * direction,
            y: position.y
        )
        
        addChild(hitBox)
        activeHitBox = hitBox
        
        let wait = SKAction.wait(forDuration: 0.2)
        let finish = SKAction.run { [weak self] in
            self?.activeHitBox?.removeFromParent()
            self?.activeHitBox = nil
            self?.state = previousState
        }
        
        run(SKAction.sequence([wait, finish]))
    }
    
    // movement states
    
    func jump() {
        guard state == .idle || state == .walking else { return }
        
        state = .jumping
        
        let jumpHeight: CGFloat = 400
        
        let jumpAction = SKAction.moveBy(x: 0, y: jumpHeight, duration: 0.4)
        jumpAction.timingMode = .easeOut
        
        let fallAction = SKAction.moveBy(x: 0, y: -jumpHeight, duration: 0.3)
        fallAction.timingMode = .easeIn
        
        run(SKAction.sequence([jumpAction, fallAction])) { [weak self] in
            self?.state = .idle
        }
    }
    
    func startBlock() {
        guard state == .idle || state == .walking else { return }
        state = .blocking
    }
    
    func stopBlock() {
        if state == .blocking {
            state = .idle
        }
    }
    
    func startDuck() {
        guard state == .idle || state == .walking else { return }
        state = .ducking
        yScale = 0.5
    }
    
    func stopDuck() {
        if state == .ducking {
            state = .idle
            yScale = 1.0
        }
    }
    
    // animation
    
    func updateAnimation() {
        let idleTextures = makeTextures(from: idleFrameNames())
        let walkTextures = makeTextures(from: walkFrameNames())
        
        removeAction(forKey: "anim")
        
        switch state {
        case .idle, .ducking, .blocking:
            if let first = idleTextures.first {
                texture = first
            }
            if idleTextures.count > 1 {
                run(SKAction.repeatForever(SKAction.animate(with: idleTextures, timePerFrame: 0.18)), withKey: "anim")
            }
            
        case .walking:
            if let first = walkTextures.first {
                texture = first
            }
            if walkTextures.count > 1 {
                run(SKAction.repeatForever(SKAction.animate(with: walkTextures, timePerFrame: 0.12)), withKey: "anim")
            }
            
        case .attacking:
            break
            
        case .jumping:
            break
            
        case .ko:
            break
        }
    }
    
    // damage
    
    func takeDamage(_ amount: Int) {
        if state == .blocking { return }
        
        self.health -= CGFloat(amount)
        
        let flash = SKAction.sequence([
            SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.1),
            SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)
        ])
        self.run(flash)
        
        if self.health <= 0 {
            self.state = .ko
        }
    }
}
