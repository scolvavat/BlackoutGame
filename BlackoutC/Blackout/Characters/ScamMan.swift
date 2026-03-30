//
//  ScamMan.swift
//  Blackout
//
//  Created by Michael Marion on 1/29/26.
//

internal import SpriteKit 

class ScamMan: Fighter {
    init() {
        super.init(stats: FighterStats.defaultStats, name: "SCAM MAN")
        self.texture = SKTexture(imageNamed: "scamMan")
        self.size = CGSize(width: 450, height: 750)
       
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}
