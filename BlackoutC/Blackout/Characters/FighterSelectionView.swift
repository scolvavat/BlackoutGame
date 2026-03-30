//
//  FighterSelectionView.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 2/17/26.
//

import SwiftUI

struct SelectableFighter: Hashable {
    var name: String
    var assetName: String
}

struct FighterSelectionView: View {

    private let fighters: [SelectableFighter] = [
        SelectableFighter(name: "Beezy", assetName: "beezy"),
        SelectableFighter(name:"Boss Man", assetName: "bossMan"),
        SelectableFighter(name: "Biggie", assetName: "biggie"),
        SelectableFighter(name:"Groovy", assetName: "groovy"),
        SelectableFighter(name: "Scam Man", assetName: "scamMan")
     
    ]
    
    private let columns = [
        GridItem(.fixed(50), spacing: 200),
        GridItem(.fixed(50), spacing: 200),
        GridItem(.fixed(50), spacing: 200)
    ]
    
    var body: some View {
        ZStack {
            Color(.customBlack)
                .ignoresSafeArea()
            
            NavigationStack {
                VStack {
                    Text("PICK A FIGHTER")
                        .font(.custom("Gameplay", size: 50))
                        .foregroundStyle(.customYellow)
                        .padding(50)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(fighters, id: \.self) { fighter in
                            NavigationLink {
                                MapSelectionView()
                            } label: {
                                FighterCardView(fighter: fighter)
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
        FighterSelectionView()
    }
    
}

            // Ensure your Card View looks like this to match the types:
//            struct FighterCardView: View {
//                let fighter: SelectableFighter
//
//                var body: some View {
//                    VStack {
//                        Image(fighter.assetName)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 80, height: 80)
//                        Text(fighter.name)
//                            .font(.custom("Gameplay", size: 12))
//                            .foregroundColor(.white)
//                    }
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.3)))
//                }
//            }
            
//#Preview {
//    FighterSelectionView(onFighterPicked: (Character) -> Void)
//    
//}

