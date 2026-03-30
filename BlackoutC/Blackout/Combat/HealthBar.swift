//
//  HealthBar.swift
//  Blackout
//
//  Created by Michael Marion on 2/9/26.
//

import SwiftUI

struct HealthBar: View {
    var health: Int
    var maxHealth: Int
    var color: Color
    var isFlipped: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: isFlipped ? .trailing : .leading) {
          
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.black.opacity(0.5))
                
             
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(health) / CGFloat(maxHealth))
                
               
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white.opacity(0.8), lineWidth: 2)
            }
        }
    }
}
