//
//  Biggie.swift
//  Blackout
//
//  Created by Michael Marion on 1/29/26.
//

internal import SpriteKit

class Biggie: Fighter {
    init() {
        super.init(stats: FighterStats.defaultStats, name: "BIGGIE")
        self.texture = SKTexture(imageNamed: "biggieIdleTwo")
        self.size = CGSize(width: 450, height: 750)
        updateAnimation()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}
