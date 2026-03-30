//
//  Groovy.swift
//  Blackout
//
//  Created by Michael Marion on 1/29/26.
//

internal import SpriteKit

class Groovy: Fighter {
    init() {
        super.init(stats: FighterStats.defaultStats, name: "GROOVY")
        self.texture = SKTexture(imageNamed: "groovyIdleOne")
        self.size = CGSize(width: 450, height: 750)
        updateAnimation()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}
