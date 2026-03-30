//
//  FighterData.swift
//  Blackout
//
//  Created by Michael Marion on 2/3/26.
//

import SwiftUI

struct FighterData: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let health: Double
    let attack: Double
}
