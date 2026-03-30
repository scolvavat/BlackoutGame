//
//  GameView.swift
//  Blackout
//
//  Created by Michael Marion on 2/4/26.
//

import SwiftUI
internal import SpriteKit
import AVFoundation
import GameController

struct GameView: View {
    
    // scene and input
    
    @StateObject private var gameScene: GameScene
    @StateObject private var music = MusicPlayer()
    @StateObject private var keyboard = KeyboardInputManager()
    
    @State private var isMovingLeft = false
    @State private var isMovingRight = false
    @State private var movementTimer: Timer? = nil
    @State private var keyboardTimer: Timer? = nil
    @State private var isPaused = false
    
    let isVersusMode: Bool
    var onReturnToCharacterSelect: () -> Void = {}
    
    // init
    
    init(
        p1Builder: @escaping () -> Fighter = { Beezy() },
        p2Builder: @escaping () -> Fighter = { Biggie() },
        isVersusMode: Bool = false,
        onReturnToCharacterSelect: @escaping () -> Void = {}
    ) {
        self.isVersusMode = isVersusMode
        self.onReturnToCharacterSelect = onReturnToCharacterSelect
        _gameScene = StateObject(wrappedValue: {
            let scene = GameScene(
                size: CGSize(width: 3005, height: 2536),
                p1Builder: p1Builder,
                p2Builder: p2Builder,
                isVersusMode: isVersusMode
            )
            scene.scaleMode = .aspectFill
            return scene
        }())
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
                .onAppear {
                    configureKeyboardHandlers()
                    startKeyboardLoop()
                    music.play()
                    applyPauseState()
                }
                .onDisappear {
                    movementTimer?.invalidate()
                    movementTimer = nil
                    keyboardTimer?.invalidate()
                    keyboardTimer = nil
                    keyboard.onKeyDown = nil
                    keyboard.onKeyUp = nil
                }
            
            VStack {
                HStack {
                    Button {
                        togglePause()
                    } label: {
                        Image(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .shadow(radius: 3)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if !isPaused {
                            music.toggle()
                        }
                    }) {
                        Image(systemName: music.isPlaying ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .font(.system(size: 18, weight: .bold))
                            .padding(8)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .padding(.top, 12)
                    .padding(.trailing, 12)
                }
                Spacer()
            }
            
            VStack {
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(gameScene.player1.characterName)
                            .font(.system(size: 20, weight: .black, design: .monospaced))
                            .foregroundColor(.yellow)
                            .italic()
                        
                        HealthBar(health: Int(gameScene.player1.health), maxHealth: 100, color: .yellow, isFlipped: false)
                            .frame(height: 20)
                            .frame(maxWidth: .infinity)
                    }
                    
                    VStack {
                        if gameScene.isGameOver {
                            Text("K.O.")
                                .font(.system(size: 80, weight: .black, design: .rounded))
                                .foregroundColor(.red)
                                .italic()
                                .shadow(color: .black, radius: 5)
                                .transition(.scale)
                        } else if isVersusMode {
                            Text("VS MODE")
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(.white)
                                .padding(.top, 20)
                                .shadow(radius: 2)
                        } else {
                            Text("VS")
                                .font(.system(size: 30, weight: .black))
                                .foregroundColor(.white)
                                .padding(.top, 20)
                                .shadow(radius: 2)
                        }
                    }
                    .frame(width: 120)
                    .animation(.spring(), value: gameScene.isGameOver)
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(gameScene.player2.characterName)
                            .font(.system(size: 20, weight: .black, design: .monospaced))
                            .foregroundColor(.blue)
                            .italic()
                        
                        HealthBar(health: Int(gameScene.player2.health), maxHealth: 100, color: .blue, isFlipped: true)
                            .frame(height: 20)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 60)
                .padding(.top, 20)
                
                Spacer()
                
                HStack {
                    VStack(spacing: 15) {
                        Button(action: {
                            if !gameScene.isGameOver && !isPaused {
                                gameScene.player1.jump()
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 70))
                                .frame(width: 90, height: 90)
                        }
                        
                        HStack(spacing: 30) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: 70))
                                .frame(width: 90, height: 90)
                                .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
                                    if !gameScene.isGameOver && !isPaused {
                                        isMovingLeft = pressing
                                        
                                        if pressing {
                                            gameScene.player1.faceLeft()
                                            gameScene.player1.startWalking()
                                            startMovementLoop()
                                        } else {
                                            stopMovementLoopIfNeeded()
                                            if !isMovingRight && !keyboard.isPressed(.keyA) && !keyboard.isPressed(.keyD) {
                                                gameScene.player1.stopWalking()
                                            }
                                        }
                                    }
                                }, perform: {})
                            
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 70))
                                .frame(width: 90, height: 90)
                                .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
                                    if !gameScene.isGameOver && !isPaused {
                                        isMovingRight = pressing
                                        
                                        if pressing {
                                            gameScene.player1.faceRight()
                                            gameScene.player1.startWalking()
                                            startMovementLoop()
                                        } else {
                                            stopMovementLoopIfNeeded()
                                            if !isMovingLeft && !keyboard.isPressed(.keyA) && !keyboard.isPressed(.keyD) {
                                                gameScene.player1.stopWalking()
                                            }
                                        }
                                    }
                                }, perform: {})
                        }
                        
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 70))
                            .frame(width: 90, height: 90)
                            .foregroundColor(.blue)
                            .onLongPressGesture(minimumDuration: 0, pressing: { isPressing in
                                if !gameScene.isGameOver && !isPaused {
                                    if isPressing {
                                        gameScene.player1.startDuck()
                                    } else {
                                        gameScene.player1.stopDuck()
                                    }
                                }
                            }, perform: {})
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        ActionButton(label: "Y", color: .yellow) {
                            if !gameScene.isGameOver && !isPaused {
                                gameScene.player1.attack(type: .highPunch)
                            }
                        }
                        
                        HStack(spacing: 15) {
                            ActionButton(label: "X", color: .blue) {
                                if !gameScene.isGameOver && !isPaused {
                                    gameScene.player1.attack(type: .lowPunch)
                                }
                            }
                            
                            Circle()
                                .fill(Color.gray.opacity(0.8))
                                .frame(width: 60, height: 60)
                                .overlay(Text("BR").foregroundColor(.white).bold())
                                .onLongPressGesture(minimumDuration: 0, pressing: { isPressing in
                                    if !gameScene.isGameOver && !isPaused {
                                        if isPressing {
                                            gameScene.player1.startBlock()
                                        } else {
                                            gameScene.player1.stopBlock()
                                        }
                                    }
                                }, perform: {})
                            
                            ActionButton(label: "B", color: .red) {
                                if !gameScene.isGameOver && !isPaused {
                                    gameScene.player1.attack(type: .highKick)
                                }
                            }
                        }
                        
                        ActionButton(label: "A", color: .green) {
                            if !gameScene.isGameOver && !isPaused {
                                gameScene.player1.attack(type: .lowKick)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .opacity(gameScene.isGameOver || isPaused ? 0.5 : 1.0)
                .disabled(gameScene.isGameOver || isPaused)
            }
            
            if isVersusMode {
                VStack {
                    Spacer()
                    Text("P1: WASD + Z/C    P2: arrows + N/M    ESC: pause")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 8)
                }
            }

            // pause menu
            
            if isPaused {
                VStack(spacing: 20) {
                    Text("GAME PAUSED")
                        .font(.system(size: 40, weight: .black))
                        .foregroundColor(.white)
                    
                    Button("Resume") {
                        togglePause()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Restart Match") {
                        gameScene.resetGame()
                        togglePause()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Character Select") {
                        returnToCharacterSelect()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(30)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
            }
            
            
            if gameScene.isGameOver {
                VStack(spacing: 16) {
                    Text("Winner: \(gameScene.winnerName)")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                    
                    HStack(spacing: 12) {
                        Button("Rematch") {
                            gameScene.resetGame()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                        
                        if !isVersusMode {
                            Button("Next Level") {
                                gameScene.advanceToNextLevel()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                        }
                    }
                }
                .padding(24)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(radius: 10)
            }
        }
    }
    
    // keyboard actions
    
    private func configureKeyboardHandlers() {
        keyboard.onKeyDown = { key in
            guard !gameScene.isGameOver else { return }
            
            switch key {
            case .escape:
                togglePause()
                
            case .keyW:
                if !isPaused {
                    gameScene.player1.jump()
                }
                
            case .keyS:
                if !isPaused {
                    gameScene.player1.startDuck()
                }
                
            case .keyZ:
                if !isPaused {
                    gameScene.player1.attack(type: .lowPunch)
                }
                
            case .keyC:
                if !isPaused {
                    gameScene.player1.attack(type: .highKick)
                }
                
            case .upArrow:
                if isVersusMode && !isPaused {
                    gameScene.player2.jump()
                }
                
            case .downArrow:
                if isVersusMode && !isPaused {
                    gameScene.player2.startDuck()
                }
                
            case .keyN:
                if isVersusMode && !isPaused {
                    gameScene.player2.attack(type: .lowPunch)
                }
                
            case .keyM:
                if isVersusMode && !isPaused {
                    gameScene.player2.attack(type: .highKick)
                }
                
            default:
                break
            }
        }
        
        keyboard.onKeyUp = { key in
            switch key {
            case .keyS:
                gameScene.player1.stopDuck()
                
            case .downArrow:
                if isVersusMode {
                    gameScene.player2.stopDuck()
                }
                
            default:
                break
            }
        }
    }
    
    // pause
    
    private func togglePause() {
        isPaused.toggle()
        applyPauseState()
    }
    
    private func applyPauseState() {
        if isPaused {
            isMovingLeft = false
            isMovingRight = false
            movementTimer?.invalidate()
            movementTimer = nil
            gameScene.player1.stopWalking()
            gameScene.player1.stopBlock()
            gameScene.player1.stopDuck()
            gameScene.player2.stopWalking()
            gameScene.player2.stopBlock()
            gameScene.player2.stopDuck()
            gameScene.isPaused = true
            gameScene.view?.isPaused = true
            music.setPaused(true)
        } else {
            gameScene.isPaused = false
            gameScene.view?.isPaused = false
            music.setPaused(false)
        }
    }
    
    // leave the match and go back to fighter select
    
    private func returnToCharacterSelect() {
        isPaused = false
        isMovingLeft = false
        isMovingRight = false
        movementTimer?.invalidate()
        movementTimer = nil
        keyboardTimer?.invalidate()
        keyboardTimer = nil
        keyboard.onKeyDown = nil
        keyboard.onKeyUp = nil
        gameScene.player1.stopWalking()
        gameScene.player1.stopBlock()
        gameScene.player1.stopDuck()
        gameScene.player2.stopWalking()
        gameScene.player2.stopBlock()
        gameScene.player2.stopDuck()
        gameScene.isPaused = false
        gameScene.view?.isPaused = false
        music.pause()
        onReturnToCharacterSelect()
    }
    
    // movement
    
    private func startMovementLoop() {
        guard movementTimer == nil else { return }
        
        movementTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
            guard !gameScene.isGameOver else { return }
            guard !isPaused else { return }
            
            let speed: CGFloat = 6
            var didMove = false
            
            if isMovingLeft {
                gameScene.player1.faceLeft()
                gameScene.player1.position.x -= speed
                didMove = true
            }
            
            if isMovingRight {
                gameScene.player1.faceRight()
                gameScene.player1.position.x += speed
                didMove = true
            }
            
            if didMove {
                gameScene.player1.startWalking()
            } else if !keyboard.isPressed(.keyA) && !keyboard.isPressed(.keyD) {
                gameScene.player1.stopWalking()
            }
        }
    }
    
    private func stopMovementLoopIfNeeded() {
        if !isMovingLeft && !isMovingRight {
            movementTimer?.invalidate()
            movementTimer = nil
            
            if !keyboard.isPressed(.keyA) && !keyboard.isPressed(.keyD) {
                gameScene.player1.stopWalking()
            }
        }
    }
    
    private func startKeyboardLoop() {
        guard keyboardTimer == nil else { return }
        
        keyboardTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
            guard !gameScene.isGameOver else { return }
            guard !isPaused else { return }
            
            let speed: CGFloat = 6
            
            var p1DidMove = false
            if keyboard.isPressed(.keyA) {
                gameScene.player1.faceLeft()
                gameScene.player1.position.x -= speed
                p1DidMove = true
            }
            if keyboard.isPressed(.keyD) {
                gameScene.player1.faceRight()
                gameScene.player1.position.x += speed
                p1DidMove = true
            }
            
            if p1DidMove {
                gameScene.player1.startWalking()
            } else if !isMovingLeft && !isMovingRight {
                gameScene.player1.stopWalking()
            }
            
            if isVersusMode {
                var p2DidMove = false
                
                if keyboard.isPressed(.leftArrow) {
                    gameScene.player2.faceLeft()
                    gameScene.player2.position.x -= speed
                    p2DidMove = true
                }
                
                if keyboard.isPressed(.rightArrow) {
                    gameScene.player2.faceRight()
                    gameScene.player2.position.x += speed
                    p2DidMove = true
                }
                
                if p2DidMove {
                    gameScene.player2.startWalking()
                } else {
                    gameScene.player2.stopWalking()
                }
            }
        }
    }
}

struct ActionButton: View {
    let label: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 70, height: 70)
                Text(label)
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.white)
            }
        }
    }
}
