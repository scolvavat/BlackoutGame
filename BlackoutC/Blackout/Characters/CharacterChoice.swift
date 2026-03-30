//
//  CharacterChoice.swift
//  YourProjectName
//
//  Created by YourName on 2026-03-17.
//

import Foundation

/// Represents a selectable character choice used by GameControllerView.
enum CharacterChoice {
    case warrior
    case mage
    case rogue

    /// The user-facing display name of the character choice.
    var displayName: String {
        switch self {
        case .warrior:
            return "Warrior"
        case .mage:
            return "Mage"
        case .rogue:
            return "Rogue"
        }
    }

    /// The asset name associated with this character choice (e.g., for images or sprites).
    var assetName: String {
        switch self {
        case .warrior:
            return "warrior"
        case .mage:
            return "mage"
        case .rogue:
            return "rogue"
        }
    }

    /// Converts this choice into a `Character` model instance.
    ///
    /// - Note: This implementation assumes a `Character` initializer
    ///   that accepts a single `name` parameter: `Character(name: String)`.
    ///   Adjust this method if your `Character` model requires different initializers.
    ///
    /// - Returns: A `Character` instance representing this choice.
    func toCharacter() -> Character {
        // TODO: Adapt this initializer to match your Character model if needed.
        return Character(name: displayName, assetName: assetName)
    }
}

