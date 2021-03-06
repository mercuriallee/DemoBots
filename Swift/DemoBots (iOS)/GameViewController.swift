/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A `UIViewController` subclass that stores references to game-wide input sources and managers.
*/

import UIKit
import SpriteKit

class GameViewController: UIViewController, SceneManagerDelegate {
    // MARK: Properties
    
    /// A placeholder logo view that is displayed before the home scene is loaded.
    @IBOutlet weak var logoView: UIImageView!
    
    /// A manager for coordinating scene resources and presentation.
    var sceneManager: SceneManager!

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
            Set up the `touchControlInputSource` to cover the entire view, and
            size the controls to a reasonable value.
        */
        let viewSize = view.bounds.size
        let controlLength = min(GameplayConfiguration.TouchControl.minimumControlSize, viewSize.width * GameplayConfiguration.TouchControl.idealRelativeControlSize)
        let controlSize = CGSize(width: controlLength, height: controlLength)
        
        let touchControlInputSource = TouchControlInputSource(frame: view.bounds, thumbStickControlSize: controlSize)
        let player = Player(nativeControlInputSource: touchControlInputSource)
        let gameSession = GameSession(player: player)
        
        // Load the initial home scene.
        let skView = view as! SKView
        sceneManager = SceneManager(presentingView: skView, gameSession: gameSession)
        sceneManager.delegate = self
        
        sceneManager.transitionToSceneWithSceneIdentifier(.Home)
    }
    
    // Hide status bar during game play.
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: SceneManagerDelegate
    
    func sceneManagerDidTransitionToScene(scene: SKScene) {
        // Fade out the app's initial loading `logoView` if it is visible.
        UIView.animateWithDuration(0.2, delay: 0.0, options: [], animations: {
            self.logoView.alpha = 0.0
        }, completion: { _ in
            self.logoView.hidden = true
        })
    }
}
