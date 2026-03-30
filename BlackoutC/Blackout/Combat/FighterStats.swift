//
//  FighterStats.swift
//  Blackout
//
//  Created by Michael Marion on 1/28/26.
//

internal import SpriteKit

struct FighterStats {
    let maxHealth: Int
    let attack: Int
    let defense: Int
    let speed: Double
    static var defaultStats: FighterStats {
                return FighterStats(maxHealth: 100, attack: 10, defense: 5, speed: 1.0)
            }
        }
    


