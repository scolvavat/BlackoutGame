//
//  BossMan.swift
//  Blackout
//
//  Created by Michael Marion on 1/29/26.
//

internal import SpriteKit

class BossMan: Fighter {
    init() {
        super.init(stats: FighterStats.defaultStats, name: "Boss Man")
        self.texture = SKTexture(imageNamed: "bossMan")
        self.size = CGSize(width: 450, height: 750)
       
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}
