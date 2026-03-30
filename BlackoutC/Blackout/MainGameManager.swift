//
//  MainGameManager.swift
//  Blackout
//
//  Created by Michael Marion on 2/11/26.
//

import SwiftUI

struct MainGameManager: View {
    @State private var p1Choice: FighterSelection?
    @State private var p2Choice: FighterSelection?
    @State private var gameStarted = false
    
    var body: some View {
        if gameStarted, let p1 = p1Choice, let p2 = p2Choice {
            GameView(
                p1Builder: { p1.makeFighter() },
                p2Builder: { p2.makeFighter() }
            )
        } else {
            CharacterSelectView(
                player1Selection: $p1Choice,
                player2Selection: $p2Choice,
                isSelectionComplete: $gameStarted
            )
        }
    }
}
