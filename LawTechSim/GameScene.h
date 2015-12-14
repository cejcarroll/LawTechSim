//
//  GameScene.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/5/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameControlView.h"

/**
 GameScene represents the gameplay screen of sprites - Character, Map, and NPCs
 */
@interface GameScene : SKScene

/**
 Redirect game controller input from GameViewController
 
 @param state GameControlView's state pressed
 */
- (void)redirectGameInput:(GameControlViewState)state;

@end
