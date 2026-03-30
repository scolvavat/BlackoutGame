//
//  PauseMenuView.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 3/16/26.
//


import SwiftUI

struct PauseMenuView: View {
    var body: some View {
        ZStack {
           
            Color(.customBlack)
                .ignoresSafeArea()
            
            VStack(spacing: 60) {
                Spacer()
                
               
                Button(action: {
                
                    print("Resume game")
                }) {
                    Text("RESUME")
                        .font(.custom("Gameplay", size: 64))
                        .foregroundColor(Color(.customYellow))
                        .tracking(4)
                }
                
               
                Button(action: {
                  
                    print("End game")
                }) {
                    Text("END GAME")
                        .font(.custom("Gameplay", size: 64))
                        .foregroundColor(.white)
                        .tracking(4)
                }
                
                Spacer()
            }
        }
    }
}
