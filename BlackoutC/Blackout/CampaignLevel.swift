//
//  CampaignLevel.swift
//  Blackout Fight in Detroit
//
//  Created by Michael Marion on 3/16/26.
//

import Foundation
internal import Combine


struct CampaignLevel: Identifiable, Codable {
    let id: Int
    let opponent: Character
    let difficulty: Int
    let isBoss: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case opponentName
        case opponentAssetName
        case difficulty
        case isBoss
    }

    init(id: Int, opponent: Character, difficulty: Int, isBoss: Bool) {
        self.id = id
        self.opponent = opponent
        self.difficulty = difficulty
        self.isBoss = isBoss
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let opponentName = try container.decode(String.self, forKey: .opponentName)
        let opponentAssetName = try container.decode(String.self, forKey: .opponentAssetName)
        let difficulty = try container.decode(Int.self, forKey: .difficulty)
        let isBoss = try container.decode(Bool.self, forKey: .isBoss)
        self.id = id
        self.opponent = Character(name: opponentName, assetName: opponentAssetName)
        self.difficulty = difficulty
        self.isBoss = isBoss
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(opponent.name, forKey: .opponentName)
        try container.encode(opponent.assetName, forKey: .opponentAssetName)
        try container.encode(difficulty, forKey: .difficulty)
        try container.encode(isBoss, forKey: .isBoss)
    }
}


struct CampaignProgress: Codable {
    var currentLevel: Int
}


class CampaignManager: ObservableObject {
    
   
    static let shared = CampaignManager()
    
    
    @Published private(set) var currentLevelIndex: Int = 0
    
    private let saveKey = "campaign_progress"
    
   
    private(set) var levels: [CampaignLevel] = [
        
        CampaignLevel(
            id: 0,
            opponent: Character(name: "Scam Man", assetName: "scamMan"),
            difficulty: 1,
            isBoss: false
        ),
        
        CampaignLevel(
            id: 1,
            opponent: Character(name: "Shelia", assetName: "shelia"),
            difficulty: 2,
            isBoss: false
        ),
        
        CampaignLevel(
            id: 2,
            opponent: Character(name: "Rae", assetName: "rae"),
            difficulty: 3,
            isBoss: false
        ),
        
        CampaignLevel(
            id: 3,
            opponent: Character(name: "Wigz", assetName: "wigz"),
            difficulty: 4,
            isBoss: false
        ),
        
     
        CampaignLevel(
            id: 4,
            opponent: Character(name: "Boss Man", assetName: "bossMan"),
            difficulty: 6,
            isBoss: true
        )
    ]
    
    private init() {
        // All stored properties have default values; it's now safe to load saved progress
        loadProgress()
    }
}

// MARK: - Gameplay Logic
extension CampaignManager {
    
    var currentLevel: CampaignLevel {
        levels[currentLevelIndex]
    }
    
    var isCampaignComplete: Bool {
        currentLevelIndex >= levels.count
    }
    
    // Player wins fight
    func completeLevel() {
        
        guard currentLevelIndex < levels.count else { return }
        
        currentLevelIndex += 1
        saveProgress()
    }
    
    // Retry level after loss
    func retryLevel() {
        saveProgress()
    }
    
    // Reset campaign
    func resetCampaign() {
        currentLevelIndex = 0
        saveProgress()
    }
}

// MARK: - Difficulty Scaling
extension CampaignManager {
    
    func enemyHealth(base: Int) -> Int {
        let difficulty = currentLevel.difficulty
        return base + (difficulty * 20)
    }
    
    func enemyAttackSpeed(base: Double) -> Double {
        let difficulty = Double(currentLevel.difficulty)
        return base - (difficulty * 0.05)
    }
    
    func enemyReactionTime(base: Double) -> Double {
        let difficulty = Double(currentLevel.difficulty)
        return max(0.2, base - difficulty * 0.1)
    }
}

// MARK: - Save System
extension CampaignManager {
    
    private func saveProgress() {
        
        let progress = CampaignProgress(currentLevel: currentLevelIndex)
        
        if let data = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
    
    private func loadProgress() {
        
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let progress = try? JSONDecoder().decode(CampaignProgress.self, from: data)
        else {
            currentLevelIndex = 0
            return
        }
        
        currentLevelIndex = progress.currentLevel
    }
}
