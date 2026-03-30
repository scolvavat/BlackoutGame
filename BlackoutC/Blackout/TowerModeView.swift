//
//  TowerModeView.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 3/16/26.
//

import SwiftUI

struct Player: Hashable {
    var name: String
    var assetName: String
}

struct TowerModeView: View {
    
    private let players: [Player] = [
        Player(name: "Beezy", assetName: "beezy"),
        Player(name:"Boss Man", assetName: "bossMan"),
        Player(name: "Biggie", assetName: "biggie"),
        Player(name:"Groovy", assetName: "groovy"),
        Player(name: "Scam Man", assetName: "scamMan"),
        Player(name:"Tino", assetName: "tino")
    ]
    var body: some View {
        ZStack {
            Color(.customBlack)
                .ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    Text("Tower Mode")
                        .font(.custom("Gameplay", size: 50))
                        .foregroundStyle(.customYellow)
                        .padding(50)
                    ForEach(players, id: \.self) { player in
                        NavigationLink {
                            MapSelectionView()
                        } label: {
                            TowerCardView(player: player)
                        }
                    }
                }
            }
        .padding()
        }
    }
}
