//
//  MSButtonNode.swift
//  HoppyBunny
//
//  Created by Martin Walsh on 20/02/2016.
//  Copyright (c) 2016 Make School. All rights reserved.
//

import SpriteKit

enum MSButtonNodeState {
    case active, selected, hidden
}

class MSButtonNode: SKSpriteNode {
    
    /* Setup a dummy action closure */
    var selectedHandler: () -> Void = { print("No button action set") }
    
    var camera: SKNode!
    
    var initialLouchLocation = CGPoint()
    
    /* Button state management */
    var state: MSButtonNodeState = .active {
        didSet {
            switch state {
            case .active:
                /* Enable touch */
                self.isUserInteractionEnabled = true
                
                /* Visible */
                self.alpha = 1
                break
            case .selected:
                /* Semi transparent */
                self.alpha = 0.7
                break
            case .hidden:
                /* Disable touch */
                self.isUserInteractionEnabled = false
                
                /* Hide */
                self.alpha = 0
                break
            }
        }
    }
    
    /* Support for NSKeyedArchiver (loading objects from SK Scene Editor */
    required init?(coder aDecoder: NSCoder) {
        
        /* Call parent initializer e.g. SKSpriteNode */
        super.init(coder: aDecoder)
        
        /* Enable touch on button node */
        self.isUserInteractionEnabled = true
    }
    
    //init(imageNamed: String) {
        //super.init(imageNamed: imageNamed)
        //self.userInteractionEnabled = true
    //}
    
    // MARK: - Touch handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .selected
        parent?.touchesBegan(touches, with: event)
        for touch in touches {
            initialLouchLocation = touch.location(in: self)
            if camera != nil {
            initialLouchLocation.x += (camera.position.x ?? 0)
            initialLouchLocation.y += (camera.position.y ?? 0)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesBegan(touches, withEvent: event)
        parent?.touchesBegan(touches, with: event)

        for touch in touches {
            
            if camera != nil {
            if abs(touch.location(in: self).x + (camera.position.x ?? 0) - initialLouchLocation.x) > 40 {
                state = .active
                return
            }
            if abs(touch.location(in: self).y + (camera.position.y ?? 0) - initialLouchLocation.y) > 40 {
                state = .active
                return
            }
            }
        }
        selectedHandler()
        state = .active
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesMoved(touches, withEvent: event)
        parent?.touchesMoved(touches, with: event)
    }
    
}
