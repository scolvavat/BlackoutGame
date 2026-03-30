//
//  StageSelectionView.swift
//  Blackout
//
//  Created by Michael Marion on 2/4/26.
//

import SwiftUI

struct Map: Hashable {
    var name: String
    var assetName: String
}


struct StageSelectionView: View {

    private let map: [Map] = [
        Map(name: "Stage One", assetName: "stageOne"),
        Map(name:"Stage Two", assetName: "stageTwo"),
        Map(name: "Stage Three", assetName: "stageThree")
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
                            
                            } label: {
                                MapCardView(map: map)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}
