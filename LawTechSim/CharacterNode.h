//
//  CharacterNode.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/6/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#include "EntityNode.h"


/**
 States for CharacterNode
 */
typedef NS_ENUM(NSInteger, CharacterNodeState)
{
    CharacterNodeStateStill,
    CharacterNodeStateMovingLeft,
    CharacterNodeStateMovingUp,
    CharacterNodeStateMovingRight,
    CharacterNodeStateMovingDown
};

//-------------------------------------------------

/**
 Represents character entity, encapsulating texture changes / animation
 */
@interface CharacterNode : EntityNode

/**
 State representing current texture
 */
@property (nonatomic, assign) CharacterNodeState state;


/**
 Update position of sprite with delta time
 
 @param deltaTime time in seconds between frames
 */
- (void)updatePositionWithTimeInterval:(NSTimeInterval)deltaTime;


/**
 Frame to detect collisions for CharacterNode
 
 @return a CGRect indication the frame's position
 */
- (CGRect)collisionRect;


@end
