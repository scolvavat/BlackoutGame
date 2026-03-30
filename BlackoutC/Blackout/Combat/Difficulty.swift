//
//  Difficulty.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 2/12/26.
//

import SwiftUI

enum Difficulty {
    case easy, medium, hard
    
    
    var reactionTime: TimeInterval {
        switch self {
        case .easy: return 0.8
        case .medium: return 0.4
        case .hard: return 0.15
        }
    }
    
 
    var blockChance: Int {
        switch self {
        case .easy: return 3
        case .medium: return 6
        case .hard: return 9  
        }
    }
}
