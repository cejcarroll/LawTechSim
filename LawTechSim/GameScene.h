//
//  GameScene.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/5/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameControlView.h"
#import "StoryStore.h"

/**
 GameScene represents the gameplay screen of sprites - Character, Map, and NPCs
 */
@interface GameScene : SKScene <GameControlViewDelegate, StoryStoreDelegate>

@end
