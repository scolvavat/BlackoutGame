//
//  FighterSelection.swift
//  Blackout
//
//  Created by Michael Marion on 2/11/26.
//

import SwiftUI

struct FighterSelection: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let characterClass: Fighter.Type
}

extension FighterSelection {
    func makeFighter() -> Fighter {
        switch name {
        case "BEEZY", "Beezy":
            return Beezy()
        case "WIGZ", "Wigz":
            return Wigz()
        case "Groovy", "GROOVY":
            return Groovy()
        case "Boss Man":
            return BossMan()
        case "Biggie", "BIGGIE":
            return Biggie()
        case "Scam Man", "SCAM MAN":
            return ScamMan()
        default:
            return Beezy()
        }
    }
}
