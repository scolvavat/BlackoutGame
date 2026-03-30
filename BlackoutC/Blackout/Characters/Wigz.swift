//
//  Wigz.swift
//  Blackout
//
//  Created by Michael Marion on 1/29/26.
//

internal import SpriteKit 

class Wigz: Fighter {
    init() {
        super.init(stats: FighterStats.defaultStats, name: "WIGZ")
        self.texture = SKTexture(imageNamed: "wigz")
        self.size = CGSize(width: 450, height: 750)
       
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}
