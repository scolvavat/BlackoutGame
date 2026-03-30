//
//  KeyboardInputManager.swift
//  Blackout
//

import Foundation
internal import Combine
import GameController

final class KeyboardInputManager: ObservableObject {
    @Published private(set) var pressedKeys: Set<GCKeyCode> = []
    
    var onKeyDown: ((GCKeyCode) -> Void)?
    var onKeyUp: ((GCKeyCode) -> Void)?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidConnect),
            name: NSNotification.Name.GCKeyboardDidConnect,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidDisconnect),
            name: NSNotification.Name.GCKeyboardDidDisconnect,
            object: nil
        )
        
        setupKeyboard()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        GCKeyboard.coalesced?.keyboardInput?.keyChangedHandler = nil
    }
    
    func isPressed(_ key: GCKeyCode) -> Bool {
        pressedKeys.contains(key)
    }
    
    @objc private func keyboardDidConnect() {
        setupKeyboard()
    }
    
    @objc private func keyboardDidDisconnect() {
        DispatchQueue.main.async {
            self.pressedKeys.removeAll()
        }
    }
    
    private func setupKeyboard() {
        GCKeyboard.coalesced?.keyboardInput?.keyChangedHandler = { [weak self] _, _, keyCode, pressed in
            guard let self else { return }
            
            DispatchQueue.main.async {
                if pressed {
                    let inserted = self.pressedKeys.insert(keyCode).inserted
                    if inserted {
                        self.onKeyDown?(keyCode)
                    }
                } else {
                    self.pressedKeys.remove(keyCode)
                    self.onKeyUp?(keyCode)
                }
            }
        }
    }
}
