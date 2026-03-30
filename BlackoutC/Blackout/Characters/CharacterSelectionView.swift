import SwiftUI

struct CharacterSelectView: View {
    
    @Binding var player1Selection: FighterSelection?
    @Binding var player2Selection: FighterSelection?
    @Binding var isSelectionComplete: Bool
    
    let fighters: [FighterSelection] = [
        FighterSelection(name: "BEEZY", imageName: "beezy", characterClass: Beezy.self),
        FighterSelection(name: "WIGZ", imageName: "wigz", characterClass: Wigz.self),
        FighterSelection(name: "Groovy", imageName: "groovy", characterClass: Groovy.self),
        FighterSelection(name: "Boss Man", imageName: "bossMan", characterClass: BossMan.self),
        FighterSelection(name: "Biggie", imageName: "biggie", characterClass: Biggie.self),
        FighterSelection(name: "Scam Man", imageName: "scamMan", characterClass: ScamMan.self)
    ]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            Image("backGroundOne")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                Text("SELECT YOUR FIGHTER")
                    .font(.custom("Gameplay", size: 40))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(fighters) { fighter in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.45))
                            
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectionColor(for: fighter), lineWidth: 4)
                            
                            VStack(spacing: 8) {
                                Image(fighter.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 90, height: 90)
                                
                                Text(fighter.name)
                                    .font(.custom("Gameplay", size: 14))
                                    .foregroundColor(.white)
                            }
                            .padding(8)
                            
                            VStack {
                                HStack {
                                    if player1Selection?.id == fighter.id {
                                        Text("P1")
                                            .font(.custom("Gameplay", size: 14))
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.yellow)
                                            .clipShape(Capsule())
                                    }
                                    
                                    Spacer()
                                    
                                    if player2Selection?.id == fighter.id {
                                        Text("P2")
                                            .font(.custom("Gameplay", size: 14))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.red)
                                            .clipShape(Capsule())
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(8)
                        }
                        .frame(width: 140, height: 140)
                        .onTapGesture {
                            selectFighter(fighter)
                        }
                    }
                }
                .padding(.horizontal, 80)
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(spacing: 10) {
                        Text(player1Selection?.name ?? "PLAYER 1")
                            .font(.custom("Gameplay", size: 24))
                            .foregroundColor(.yellow)
                        
                        if let p1 = player1Selection {
                            Image(modelImageName(for: p1))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 260, height: 340)
                        } else {
                            Color.clear
                                .frame(width: 260, height: 340)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Text(player2Selection?.name ?? "PLAYER 2")
                            .font(.custom("Gameplay", size: 24))
                            .foregroundColor(.red)
                        
                        if let p2 = player2Selection {
                            Image(modelImageName(for: p2))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 260, height: 340)
                                .scaleEffect(x: -1, y: 1)
                        } else {
                            Color.clear
                                .frame(width: 260, height: 340)
                        }
                    }
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 20)
                
                if player1Selection != nil && player2Selection != nil {
                    Button("START MATCH") {
                        isSelectionComplete = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    func selectFighter(_ fighter: FighterSelection) {
        if player1Selection == nil {
            player1Selection = fighter
        } else if player2Selection == nil {
            player2Selection = fighter
        } else {
            player1Selection = fighter
            player2Selection = nil
        }
    }
    
    func selectionColor(for fighter: FighterSelection) -> Color {
        if player1Selection?.id == fighter.id { return .yellow }
        if player2Selection?.id == fighter.id { return .red }
        return .white.opacity(0.2)
    }
    
    func modelImageName(for fighter: FighterSelection) -> String {
        switch fighter.name {
        case "BEEZY":
            return "beezyLoading"
        case "WIGZ":
            return "wigzLoading"
        case "Groovy":
            return "groovyLoading"
        case "Boss Man":
            return "bossManLoading"
        case "Biggie":
            return "biggieLoading"
        case "Scam Man":
            return "scamManLoading"
        default:
            return fighter.imageName
        }
    }
}
