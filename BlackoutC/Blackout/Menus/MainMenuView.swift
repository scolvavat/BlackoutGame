//
//  MainMenuView.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 2/17/26.
//

import SwiftUI

struct MainMenuView: View {
    var onStartPressed: () -> Void
    var onVSModePressed: () -> Void = {}

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Text("BLACKOUT: FIGHT IN DETROIT")
                    .font(.custom("Gameplay", size: 60))
                    .foregroundColor(.yellow)
                
                Spacer()
                
                VStack(spacing: 18) {
                    Button(action: {
                        onStartPressed()
                    }) {
                        Text("START GAME")
                            .font(.custom("Gameplay", size: 30))
                            .padding()
                            .frame(minWidth: 260)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        onVSModePressed()
                    }) {
                        Text("VS MODE")
                            .font(.custom("Gameplay", size: 30))
                            .padding()
                            .frame(minWidth: 260)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
                
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        print("Settings tapped")
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.customYellow))
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.trailing, 30)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}
