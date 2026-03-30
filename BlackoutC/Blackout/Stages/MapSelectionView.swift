//
//  MapSelectionView.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 2/19/26.
//

import SwiftUI

struct GameMap: Hashable {
    var name: String
    var assetName: String
}


struct MapSelectionView: View {

    private let map: [GameMap] = [
        GameMap(name: "Stage One", assetName: "stageOne"),
        GameMap(name:"Stage Two", assetName: "stageTwo"),
        GameMap(name: "Stage Three", assetName: "stageThree")
    ]
    
    private let columns = [
        GridItem(.fixed(55), spacing: 200),
        GridItem(.fixed(55), spacing: 200),
        GridItem(.fixed(55), spacing: 200)
    ]
    
    var body: some View {
        ZStack {
            Color(.customBlack)
                .ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    Text("Select Your Map")
                        .font(.custom("Gameplay", size: 50))
                        .foregroundStyle(.customYellow)
                        .padding(20)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(map, id: \.self) { map in
                            NavigationLink {
//                                PauseMenuView()
                            } label: {
//                                MapCardView(map: map)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    NavigationStack{
        MapSelectionView()
    }
    
}

