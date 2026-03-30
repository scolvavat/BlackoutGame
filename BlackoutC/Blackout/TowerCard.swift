//
//  TowerCard.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 3/16/26.
//

import SwiftUI

struct TowerCardView: View {
    let player: Player
    
    var body: some View {
        VStack {
            
            Image(player.assetName)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius:0))
        }
        .frame(width: 125, height: 125)
        .padding()
        .background(RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.customNavy))
    }
}

