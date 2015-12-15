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


/**
 Returns NSString entityId of nearby NPC, if there are any.
 Threshold is defined by an internal constant kNearbyThresholdDistance
 
 @return NSString entityId, or nil if there are no nearby characters
 */
- (NSString *)nearbyEntityForCharacter;


@end
