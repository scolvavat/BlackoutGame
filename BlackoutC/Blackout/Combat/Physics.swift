//
//  Physics.swift
//  Blackout
//
//  Created by Michael Marion on 1/28/26.
//

internal import SpriteKit

struct Physics {
    static let fighter: UInt32 = 0x1 << 0
    static let hitBox: UInt32  = 0x1 << 1
    static let hurtBox: UInt32 = 0x1 << 2
    static let background: UInt32 = 0x1 << 3
}

