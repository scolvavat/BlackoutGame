//
//  MapCard.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 2/17/26.
//

import SwiftUI
internal import Combine

struct MapCardView: View {
    let map: Map
    
    var body: some View {
        VStack {
            
            Image(map.assetName)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius:20))

            Text(map.name)
                .font(Font.custom("Gameplay",size:25  ))
                .foregroundStyle(.customYellow)
        }
        .frame(width: 230, height: 230)
        .padding()
        
    }
}

#Preview {
    MapCardView(map: Map(name: "Stage One", assetName: "stageOne"))
}
