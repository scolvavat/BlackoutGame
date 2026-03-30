//
//  GameScene.swift
//  Blackout
//
//  Created by Michael Marion on 1/22/26.
//

internal import SpriteKit
import GameplayKit
internal import Combine
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    @Published var isGameOver = false
    @Published var winnerName = ""
    @Published var currentLevel: Int = 0
    
    let isVersusMode: Bool
    
    private var opponentBuilders: [() -> Fighter] = [
        { Biggie() },
        { Groovy() }
    ]
    
    var player1: Fighter
    var player2: Fighter
    private var enemyAITimer: Timer?
    
    init(size: CGSize, p1Builder: () -> Fighter, p2Builder: () -> Fighter, isVersusMode: Bool = false) {
        self.player1 = p1Builder()
        self.player2 = p2Builder()
        self.isVersusMode = isVersusMode
        super.init(size: size)
        self.player1.zPosition = 10
        self.player2.zPosition = 10
    }
    
    override init(size: CGSize) {
        self.player1 = Beezy()
        
        if let builder = opponentBuilders.first {
            self.player2 = builder()
        } else {
            self.player2 = Biggie()
        }
        
        self.isVersusMode = false
        super.init(size: size)
        self.player1.zPosition = 10
        self.player2.zPosition = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        view.showsPhysics = true
        view.showsFPS = true
        
        let stageIndex = min(currentLevel, StageManager.stages.count - 1)
        let stage = StageManager.stages[stageIndex]
        setupStage(stage)
        spawnPlayers()
        
        if !isVersusMode {
            startEnemyAI()
        }
    }
    
    private func spawnPlayers() {
        let stageIndex = min(currentLevel, StageManager.stages.count - 1)
        let stage = StageManager.stages[stageIndex]
        let groundLevel = stage.floorY + 150
        
        player1.size = CGSize(width: 450, height: 750)
        player1.position = CGPoint(x: size.width * 0.25, y: groundLevel)
        player1.faceRight()
        player1.state = .idle
        player1.configureHurtBox()
        player1.updateAnimation()
        
        player2.size = CGSize(width: 450, height: 750)
        player2.position = CGPoint(x: size.width * 0.75, y: groundLevel)
        player2.faceLeft()
        player2.state = .idle
        player2.configureHurtBox()
        player2.updateAnimation()
        
        if player1.parent == nil { addChild(player1) }
        if player2.parent == nil { addChild(player2) }
    }
    
    private func startEnemyAI() {
        enemyAITimer?.invalidate()
        enemyAITimer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true) { [weak self] _ in
            guard let self else { return }
            guard !self.isGameOver else { return }
            guard !self.isPaused else { return }
            
            let p1 = self.player1
            let p2 = self.player2
            
            switch p2.state {
            case .idle, .ducking, .walking:
                break
            default:
                return
            }
            
            guard p2.health > 0, p1.health > 0 else { return }
            
            let distance = abs(p1.position.x - p2.position.x)
            
            if distance > 520 {
                let step: CGFloat = 60
                p2.startWalking()
                
                if p2.position.x < p1.position.x {
                    p2.faceRight()
                    p2.position.x += step
                } else {
                    p2.faceLeft()
                    p2.position.x -= step
                }
                
                return
            }
            
            p2.stopWalking()
            
            if distance > 300 && Bool.random() {
                p2.jump()
                return
            }
            
            let attacks: [AttackType] = [.lowPunch, .highPunch, .lowKick, .highKick]
            if let choice = attacks.randomElement() {
                p2.attack(type: choice)
            }
        }
    }
    
    private func setupStage(_ stage: Stage) {
        let background = SKSpriteNode(imageNamed: stage.background)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)
        
        let playableFloor = stage.floorY + 150
        
        physicsBody = SKPhysicsBody(
            edgeLoopFrom: CGRect(
                x: 0,
                y: playableFloor,
                width: size.width,
                height: size.height
            )
        )
        
        physicsBody?.categoryBitMask = Physics.background
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == Physics.hitBox &&
            bodyB.categoryBitMask == Physics.hurtBox {
            handleHit(hitBoxBody: bodyA, hurtBoxBody: bodyB)
        }
        else if bodyB.categoryBitMask == Physics.hitBox &&
                bodyA.categoryBitMask == Physics.hurtBox {
            handleHit(hitBoxBody: bodyB, hurtBoxBody: bodyA)
        }
    }
    
    private func handleHit(hitBoxBody: SKPhysicsBody, hurtBoxBody: SKPhysicsBody) {
        guard !isGameOver else { return }
        
        guard let hitBox = hitBoxBody.node as? HitBox,
              let hurtBox = hurtBoxBody.node as? HurtBox,
              let target = hurtBox.parent as? Fighter else { return }
        
        if hitBox.owner === target { return }
        if target.state == .blocking { return }
        
        let gruntSound = SKAction.playSoundFileNamed("Hurt", waitForCompletion: false)
        run(gruntSound)
        
        hitBox.didHit(target: target)
        
        objectWillChange.send()
        
        let flinch = SKAction.moveBy(
            x: target.facingDirection() * -20,
            y: 0,
            duration: 0.1
        )
        
        target.run(flinch)
        
        if target.health <= 0 {
            triggerKO(winner: target === player1 ? player2 : player1)
        }
    }
    
    private func triggerKO(winner: Fighter) {
        isGameOver = true
        winnerName = winner.characterName
        objectWillChange.send()
        enemyAITimer?.invalidate()
        
        let koSound = SKAction.playSoundFileNamed("KO", waitForCompletion: false)
        run(koSound)
        
        speed = 0.5
    }
    
    func advanceToNextLevel() {
        guard isGameOver else { return }
        currentLevel = min(currentLevel + 1, opponentBuilders.count - 1)
        reconfigureForCurrentLevel()
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let reset = SKAction.run { [weak self] in
            self?.resetForCurrentLevel()
        }
        run(SKAction.sequence([fadeOut, reset, fadeIn]))
    }
    
    private func reconfigureForCurrentLevel() {
        let opponentIndex = min(currentLevel, opponentBuilders.count - 1)
        let buildOpponent = opponentBuilders[opponentIndex]
        
        if player2.parent != nil {
            player2.removeFromParent()
        }
        
        player2 = buildOpponent()
        player2.zPosition = 10
        player2.configureHurtBox()
        player2.updateAnimation()
    }
    
    private func resetForCurrentLevel() {
        isGameOver = false
        speed = 1.0
        
        player1.health = 100
        player2.health = 100
        
        removeAllChildren()
        let stageIndex = min(currentLevel, StageManager.stages.count - 1)
        let stage = StageManager.stages[stageIndex]
        setupStage(stage)
        
        if player1.parent == nil { addChild(player1) }
        if player2.parent == nil { addChild(player2) }
        
        let groundLevel = stage.floorY + 150
        
        player1.size = CGSize(width: 450, height: 750)
        player1.position = CGPoint(x: size.width * 0.25, y: groundLevel)
        player1.faceRight()
        player1.state = .idle
        player1.configureHurtBox()
        player1.updateAnimation()
        
        player2.size = CGSize(width: 450, height: 750)
        player2.position = CGPoint(x: size.width * 0.75, y: groundLevel)
        player2.faceLeft()
        player2.state = .idle
        player2.configureHurtBox()
        player2.updateAnimation()
        
        if !isVersusMode {
            startEnemyAI()
        }
        objectWillChange.send()
    }
    
    func resetGame() {
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let reset = SKAction.run { [weak self] in
            self?.resetForCurrentLevel()
        }
        run(SKAction.sequence([fadeOut, reset, fadeIn]))
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
    }
    
    deinit {
        enemyAITimer?.invalidate()
    }
}
