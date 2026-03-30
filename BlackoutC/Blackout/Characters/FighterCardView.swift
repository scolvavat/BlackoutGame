//
//  FighterCardView.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 2/17/26.
//

import SwiftUI
internal import SpriteKit

struct FighterCardView: View {
    let fighter: SelectableFighter
    
    var body: some View {
        VStack {
            
            Image(fighter.assetName)
                .resizable()
                .ignoresSafeArea()
                .clipShape(RoundedRectangle(cornerRadius: 0))
            
            
            
            
            
            Text(fighter.name)
                .font(Font.custom("Gameplay", size: 25))
                .foregroundStyle(.yellow)
        }
        
            .frame(width: 200, height: 200)
            .padding()
            .background(RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.customNavy))
    }
}

//#Preview {
//    // Sample stats for previewing
//    let sampleStats = FighterStats(maxHealth: 100, attack: 25, defense: 15, speed: 1.2)
//    let selectable = SelectableFighter(stats: sampleStats, name: "Boss Man", assetName: "bossMan")
//    FighterCardView(fighter: selectable)
//}
