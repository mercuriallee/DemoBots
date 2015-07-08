/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    An `NSViewController` subclass that stores references to game-wide input sources and managers.
*/

import Cocoa
import SpriteKit

class GameViewController: NSViewController {
    // MARK: Properties
    
    /// A manager for coordinating scene resources and presentation.
    var sceneManager: SceneManager!
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let keyboardControlInputSource = KeyboardControlInputSource()
        let player = Player(nativeControlInputSource: keyboardControlInputSource)
        let gameSession = GameSession(player: player)
        
        // Load the initial home scene.
        let skView = view as! SKView
        sceneManager = SceneManager(presentingView: skView, gameSession: gameSession)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        sceneManager.transitionToSceneWithSceneIdentifier(.Home)
    }
}
