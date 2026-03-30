//
//  Beezy.swift
//  Blackout
//
//  Created by Michael Marion on 1/29/26.
//

internal import SpriteKit

class Beezy: Fighter {
    init() {
        super.init(stats: FighterStats.defaultStats, name: "BEEZY")
        self.texture = SKTexture(imageNamed: "beezy1")
        self.size = CGSize(width: 450, height: 750)
        updateAnimation()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}
