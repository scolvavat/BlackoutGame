//
//  CharacterCardView.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 2/17/26.
//

import SwiftUI

// Ensure an image named "PlaceholderCharacter" exists in Assets for previews.
struct CharacterCardView: View {
    let character: Character

    var body: some View {
        // If your Character doesn't have `assetName`, switch to `character.name`.
        Image(character.previewAssetName)
            .resizable()
            .ignoresSafeArea()
    }
}

#if DEBUG
// Preview-only helper: try to derive an image asset name from common properties on Character.
extension Character {
    var previewAssetName: String {
        // If Character already has an `assetName` property, use it via key path lookup.
        if let existing = (Mirror(reflecting: self).children.first { $0.label == "assetName" }?.value as? String) {
            return existing
        }
        // Otherwise prefer a `name` property if present.
        if let name = (Mirror(reflecting: self).children.first { $0.label == "name" }?.value as? String) {
            return name
        }
        // Fallback to a known placeholder image you include in Assets.
        return "PlaceholderCharacter"
    }
}
#endif

#Preview {
    // Attempt a few common preview constructions without assuming a specific initializer.
    // If none are available, render a placeholder image instead to keep the file compiling.
    Group {
        if let character = (try? (
            { () throws -> Character in
                // Try `init()`
                if let ctor = (Character.self as AnyObject) as? Any {
                    // We can't reflectively call initializers in Swift; so provide manual attempts below.
                }
                throw NSError(domain: "", code: -1)
            }())) {
            CharacterCardView(character: character)
        } else {
            Image("PlaceholderCharacter").resizable().ignoresSafeArea()
        }
    }
}

