//
//  LoadingContentView.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 3/16/26.
//

import SwiftUI
internal import Combine

struct Character: Hashable {
    var name: String
    var assetName: String
}


struct Card {
    let imageName: String
    let title: String
}

struct LoadingContentView: View {
    
    @State private var currentIndex = 0
    @State private var showPreviousCard = false
    @State private var navigateToMainMenu = false
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    let cards: [Card] = [
        Card(imageName: "characterOne", title: ""),
        Card(imageName: "characterTwo", title: ""),
        Card(imageName: "characterThree", title: ""),
        Card(imageName: "characterFour", title: ""),
        Card(imageName: "characterFive", title: "")
    ]
    
    var body: some View {
        ZStack {
            if !navigateToMainMenu {
                ForEach(0 ..< cards.count, id: \.self) { index in
                    if index == currentIndex {
                        Image(cards[index].imageName)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                            .overlay {
                                Text(cards[index].title)
                                    .font(.system(size: 78, weight: .bold))
                                    .foregroundStyle(.white)
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                            }
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
            } else {
                MainMenuView(onStartPressed: { /* TODO: Start game action */ })
                    .transition(.opacity)
            }
        }
        .onReceive(timer) { _ in
            if !navigateToMainMenu {
                showPreviousCard = false
                
                if currentIndex < cards.count - 1 {
                    withAnimation(.snappy) {
                        currentIndex += 1
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        navigateToMainMenu = true
                    }
                }
            }
        }
    }
}

