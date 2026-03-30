//
//  GameViewController.swift
//  Blackout
//
//  Created by Michael Marion on 1/22/26.
//

import SwiftUI
internal import SpriteKit

struct GameCharacter: Hashable {
    let name: String
    let assetName: String
}

enum AppState {
    case mainMenu
    case characterSelect(isVersusMode: Bool)
    case gameplay(player: GameCharacter, opponent: GameCharacter, isVersusMode: Bool)
}

struct GameControllerView: View {
    
    // app flow
    @State private var currentState: AppState = .mainMenu
    
    @State private var p1Choice: FighterSelection? = nil
    @State private var p2Choice: FighterSelection? = nil
    @State private var gameStarted: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch currentState {
            // main menu
            
            case .mainMenu:
                MainMenuView(
                    onStartPressed: {
                        p1Choice = nil
                        p2Choice = nil
                        gameStarted = false
                        withAnimation {
                            currentState = .characterSelect(isVersusMode: false)
                        }
                    },
                    onVSModePressed: {
                        p1Choice = nil
                        p2Choice = nil
                        gameStarted = false
                        withAnimation {
                            currentState = .characterSelect(isVersusMode: true)
                        }
                    }
                )

            // character select
            
            case let .characterSelect(isVersusMode):
                CharacterSelectView(
                    player1Selection: $p1Choice,
                    player2Selection: $p2Choice,
                    isSelectionComplete: $gameStarted
                )
                .transition(.opacity)
                .onChange(of: gameStarted) { _, started in
                    if started, let p1 = p1Choice, let p2 = p2Choice {
                        withAnimation {
                            currentState = .gameplay(
                                player: p1.toGameCharacter(),
                                opponent: p2.toGameCharacter(),
                                isVersusMode: isVersusMode
                            )
                        }
                    }
                }

            // match
            
            case let .gameplay(player, opponent, isVersusMode):
                GameView(
                    p1Builder: { player.toFighter() },
                    p2Builder: { opponent.toFighter() },
                    isVersusMode: isVersusMode,
                    onReturnToCharacterSelect: {
                        p1Choice = nil
                        p2Choice = nil
                        gameStarted = false
                        withAnimation {
                            currentState = .characterSelect(isVersusMode: isVersusMode)
                        }
                    }
                )
                .transition(.opacity)
                .ignoresSafeArea()
            }
        }
    }
}

extension FighterSelection {
    func toGameCharacter() -> GameCharacter {
        GameCharacter(name: self.name, assetName: self.imageName)
    }
}

extension GameCharacter {
    func toFighter() -> Fighter {
        switch name {
        case "BEEZY", "Beezy":
            return Beezy()
        case "WIGZ", "Wigz":
            return Wigz()
        case "Groovy", "GROOVY":
            return Groovy()
        case "Boss Man":
            return BossMan()
        case "Biggie", "BIGGIE":
            return Biggie()
        case "Scam Man", "SCAM MAN":
            return ScamMan()
        default:
            return Beezy()
        }
    }
}

#Preview {
    GameControllerView()
}
