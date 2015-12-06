//
//  CharacterNode.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/6/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


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
@interface CharacterNode : SKSpriteNode

/**
 State representing current texture
 */
@property (nonatomic, assign) CharacterNodeState state;


/**
 Screen scale to be displayed to. This is multiplied by 2 to fit environment size of tilemap used
 */
@property (nonatomic, assign) CGFloat screenScale;


/**
 Speed of character. Default is 5
 */
@property (nonatomic, assign) NSUInteger movementSpeed;


@end
