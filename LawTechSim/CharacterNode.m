//
//  CharacterNode.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/6/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "CharacterNode.h"

@interface CharacterNode ()

/*   Actions to be executed by node to update texture   */
@property (nonatomic, strong) SKAction *stillLeftAction;
@property (nonatomic, strong) SKAction *stillUpAction;
@property (nonatomic, strong) SKAction *stillDownAction;
@property (nonatomic, strong) SKAction *stillRightAction;
@property (nonatomic, strong) SKAction *movingLeftAction;
@property (nonatomic, strong) SKAction *movingUpAction;
@property (nonatomic, strong) SKAction *movingRightAction;
@property (nonatomic, strong) SKAction *movingDownAction;

@end

@implementation CharacterNode


// TODO: Probably should organize string constants for assets if not too lazy

/// Speed of character sprites
static const NSUInteger kMovementSpeedPerSec = 100;

/// Increase sprite size by this ratio to match tilemap
static const CGFloat kScreenRatioMagnifier = 0.5;

/// Time in seconds between texture changes for animations
static const NSTimeInterval kAnimationFramerate = 0.15;

/// Size of collision box. Should be close to tile-size
static const CGSize kCollisionBoxSize = {16, 8};

/// Offset to bring bounding box closer to feet of character
static const CGFloat kCollisionBoxYOffset = 10;

static NSString *const kCharacterActionKey = @"CharacterNodeAction";

- (instancetype)init
{
    if (self = [super initWithEntityId:@"Main"])
    {
        [self setState:CharacterNodeStateStill];
        [self setScale:kScreenRatioMagnifier];
    }
    
    return self;
}


/**
 State representing current texture
 */
- (void)setState:(CharacterNodeState)state
{
    if (_state == state)
        return;
    
    [self performActionForState:state];
    _state = state;
}

/**
 Perform texture changes for given state
 
 @param state new state to represent
 */
- (void)performActionForState:(CharacterNodeState)state
{
    SKAction *execAction = nil;
    
    [self removeActionForKey:kCharacterActionKey];
    
    switch (state) {
        case CharacterNodeStateStill:
            if (self.state == CharacterNodeStateMovingLeft)
                execAction = self.stillLeftAction;
            else if (self.state == CharacterNodeStateMovingUp)
                execAction = self.stillUpAction;
            else if (self.state == CharacterNodeStateMovingRight)
                execAction = self.stillRightAction;
            else if (self.state == CharacterNodeStateMovingDown)
                execAction = self.stillDownAction;
            break;
        case CharacterNodeStateMovingLeft:
            execAction = self.movingLeftAction;
            break;
        case CharacterNodeStateMovingUp:
            execAction = self.movingUpAction;
            break;
        case CharacterNodeStateMovingRight:
            execAction = self.movingRightAction;
            break;
        case CharacterNodeStateMovingDown:
            execAction = self.movingDownAction;
            break;
    }
    
    /*   TODO: Maybe assign key? Dunno which is faster - clearing all action or specifying key */
    [self runAction:execAction
            withKey:kCharacterActionKey];
}

- (void)updatePositionWithTimeInterval:(NSTimeInterval)deltaTime
{
    CGFloat moveDist = kMovementSpeedPerSec * deltaTime;
    CGPoint newPosition = self.position;
    
    switch (self.state)
    {
        case CharacterNodeStateStill:
            break;
        case CharacterNodeStateMovingLeft:
            newPosition.x += moveDist;
            break;
        case CharacterNodeStateMovingUp:
            newPosition.y -= moveDist;
            break;
        case CharacterNodeStateMovingRight:
            newPosition.x -= moveDist;
            break;
        case CharacterNodeStateMovingDown:
            newPosition.y += moveDist;
            break;
    }
    
    [self setPosition:newPosition];
}

- (CGRect)collisionFrame
{
    CGRect frame = self.frame;

    frame.origin = self.position;
    frame.origin.y -= kCollisionBoxYOffset; // Shift down

    frame.size = kCollisionBoxSize;
    
    return frame;
}

#pragma mark - Properties

- (SKAction *)stillLeftAction
{
    if (!_stillLeftAction)
        _stillLeftAction = [SKAction setTexture:self.stlLeftTexture
                                         resize:NO];
    
    return _stillLeftAction;
}

- (SKAction *)stillUpAction
{
    if (!_stillUpAction)
        _stillUpAction = [SKAction setTexture:self.stlUpTexture
                                       resize:NO];
    
    return _stillUpAction;
}

- (SKAction *)stillRightAction
{
    if (!_stillRightAction)
        _stillRightAction = [SKAction setTexture:self.stlRightTexture
                                          resize:NO];
    
    return _stillRightAction;
}

- (SKAction *)stillDownAction
{
    if (!_stillDownAction)
        _stillDownAction = [SKAction setTexture:self.stlDownTexture
                                         resize:NO];
    
    return _stillDownAction;
}



- (SKAction *)movingLeftAction
{
    if (!_movingLeftAction)
    {
        SKAction *repeatingAction = [SKAction animateWithTextures:@[self.movLeft0Texture,
                                                                    self.stlLeftTexture,
                                                                    self.movLeft1Texture,
                                                                    self.stlLeftTexture]
                                                     timePerFrame:kAnimationFramerate];
        _movingLeftAction = [SKAction repeatActionForever:repeatingAction];
    }
    
    return _movingLeftAction;
}

- (SKAction *)movingUpAction
{
    if (!_movingUpAction)
    {
        SKAction *repeatingAction = [SKAction animateWithTextures:@[self.movUp0Texture,
                                                                    self.stlUpTexture,
                                                                    self.movUp1Texture,
                                                                    self.stlUpTexture]
                                                     timePerFrame:kAnimationFramerate];
        _movingUpAction = [SKAction repeatActionForever:repeatingAction];
    }
    
    return _movingUpAction;
}

- (SKAction *)movingRightAction
{
    if (!_movingRightAction)
    {
        SKAction *repeatingAction = [SKAction animateWithTextures:@[self.movRight0Texture,
                                                                    self.stlRightTexture,
                                                                    self.movRight1Texture,
                                                                    self.stlRightTexture]
                                                     timePerFrame:kAnimationFramerate];
        _movingRightAction = [SKAction repeatActionForever:repeatingAction];
        
    }
    
    return _movingRightAction;
}

- (SKAction *)movingDownAction
{
    if (!_movingDownAction)
    {
        SKAction *repeatingAction = [SKAction animateWithTextures:@[self.movDown0Texture,
                                                                    self.stlDownTexture,
                                                                    self.movDown1Texture,
                                                                    self.stlDownTexture]
                                                     timePerFrame:kAnimationFramerate];
        _movingDownAction = [SKAction repeatActionForever:repeatingAction];
    }
    
    return _movingDownAction;
}


@end
