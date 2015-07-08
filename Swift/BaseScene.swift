/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The base class for all scenes in the app.
*/

import SpriteKit

#if os(iOS)
import ReplayKit
#endif

/**
    A base class for all of the scenes in the app.
*/
class BaseScene: SKScene, GameSessionDelegate, ControlInputSourceGameStateDelegate {
    // MARK: Properties

    #if os(iOS)
    /// ReplayKit preview view controller used when viewing recorded content.
    var previewViewController: RPPreviewViewController?
    #endif
    
    /**
        The native size for this scene. This is the height at which the scene
        would be rendered if it did not need to be scaled to fit a window or device.
        Defaults to `zeroSize`; the actual value to use is set in `createCamera()`.
    */
    var nativeSize = CGSize.zeroSize
    
    /**
        The background node for this `BaseScene` if needed. Provided by those subclasses
        that use a background scene in their SKS file to center the scene on screen.
        Gettable-only.
    */
    var backgroundNode: SKSpriteNode? {
        return nil
    }
    
    var gameSession: GameSession! {
        didSet {
            // Listen for updates to the game session.
            gameSession.delegate = self
            
            #if os(iOS)
            /*
                Set up iOS touch controls. The player's `nativeControlInputSource`
                is added to the scene by the `BaseSceneTouchEventForwarding` extension.
            */
            addTouchInputToScene()
            #endif
        }
    }
    
    /// The current scene overlay (if any) that is displayed over this scene.
    var overlay: SceneOverlay? {
        didSet {
            oldValue?.backgroundNode.removeFromParent()
            
            if let overlay = overlay, camera = camera {
                camera.addChild(overlay.backgroundNode)
                overlay.updateScale()
            }
        }
    }
    
    /**
        A weak reference to the scene manager to call `progressToNextScene()` 
        and `repeatCurrentScene()` for scene progression.
    */
    weak var sceneManager: SceneManager!
    
    // MARK SKScene life cycle
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        updateCameraScale()
        overlay?.updateScale()
    }
    
    override func didChangeSize(oldSize: CGSize) {
        super.didChangeSize(oldSize)
        
        updateCameraScale()
        overlay?.updateScale()
    }
    
    // MARK: GameSessionDelegate
    
    func gameSessionDidUpdateControlInputSources(gameSession: GameSession) {
        // Setup all player controlInputSources to delegate game actions to `BaseScene`.
        for controlInputSource in gameSession.player.controlInputSources {
            controlInputSource.gameStateDelegate = self
        }
    }
    
    // MARK: ControlInputSourceGameStateDelegate

    func controlInputSourceDidTriggerAnyEvent(controlInputSource: ControlInputSourceType) {
        // Subclasses implement in response to any control event.
    }
    
    func controlInputSourceDidTogglePauseState(controlInputSource: ControlInputSourceType) {
        // Subclasses implement to toggle pause state.
    }
    
    #if DEBUG
    func controlInputSourceDidToggleDebugInfo(controlInputSource: ControlInputSourceType) {
        // Subclasses implement if necessary, to display useful debug info.
    }
    
    func controlInputSourceDidTriggerLevelSuccess(controlInputSource: ControlInputSourceType) {
        // Implemented by subclasses to switch to next level while debugging.
    }
    
    func controlInputSourceDidTriggerLevelFailure(controlInputSource: ControlInputSourceType) {
        // Implemented by subclasses to force failing the level while debugging.
    }
    #endif
    
    // MARK: Camera actions
    
    /**
        Creates a camera for the scene, and updates its scale.
        This method should be called when initializing an instance of a `BaseScene` subclass.
    */
    func createCamera() {
        if let backgroundNode = backgroundNode {
            // If the scene has a background node, use its size as the native size of the scene.
            nativeSize = backgroundNode.size
        }
        else {
            // Otherwise, use the scene's own size as the native size of the scene.
            nativeSize = size
        }
        
        let camera = SKCameraNode()
        self.camera = camera
        addChild(camera)
        
        updateCameraScale()
    }
    
    /// Centers the scene's camera on a given point.
    func centerCameraOnPoint(point: CGPoint) {
        if let camera = camera {
            camera.position = point
        }
    }
    
    /// Scales the scene's camera.
    func updateCameraScale() {
        /*
            Because the game is normally playing in landscape, use the scene's current and
            original heights to calulate the camera scale.
        */
        if let camera = camera {
            camera.setScale(nativeSize.height / size.height)
        }
    }
}
