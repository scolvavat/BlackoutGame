//
//  Attack.swift
//  Blackout
//
//  Created by Michael Marion on 1/28/26.
//

internal import SpriteKit


struct Attack {
    let damage: Int
    let startup: TimeInterval
    let active: TimeInterval
    let recovery: TimeInterval
    let hitBoxSize: CGSize
}

extension Fighter {
    func performAttack(_ attack: Attack) {
        guard state == .idle else { return }
        state = .attacking
        
       
    }

    func playAttackAnimation() {
        
    }
}



