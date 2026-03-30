//
//  ReturnMenu.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 3/16/26.
//

import SwiftUI

struct ReturnMenuView: View {
    @State private var navigateToFighterContent = false
    @State private var navigateToMainMenuView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.customBlack)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    Button(action: {
                        navigateToFighterContent = true
                    }) {
                        Text("Rematch")
                            .font(Font.custom("Gameplay", size: 40))
                            .foregroundColor(.black)
                            .tracking(2)
                            .frame(width: 600, height: 125)
                            .background(Color(.customYellow))
                            .cornerRadius(20)
                    }
                    Button(action: {
                        navigateToFighterContent = true
                    }) {
                        Text("Return to Fighter")
                            .font(Font.custom("Gameplay", size: 40))
                            .foregroundColor(.black)
                            .tracking(2)
                            .frame(width: 600, height: 125)
                            .background(Color(.customYellow))
                            .cornerRadius(20)
                    }
                    
                    Button(action: {
                        navigateToMainMenuView = true
                    }) {
                        Text("Return to main menu")
                            .font(Font.custom("Gameplay", size: 40))
                            .foregroundColor(.black)
                            .tracking(2)
                            .frame(width: 600, height: 125)
                            .background(Color(.customYellow))
                            .cornerRadius(20)
                    }
                    .navigationDestination(isPresented: $navigateToMainMenuView) {
                        MainMenuView(onStartPressed: { })
                    }
                    .navigationBarHidden(true)
                    
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToFighterContent) {
                FighterSelectionView()
            }
            .navigationBarHidden(true)
            
        }
    }
}
