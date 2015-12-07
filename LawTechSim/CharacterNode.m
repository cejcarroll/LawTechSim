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

static const NSUInteger kMovementSpeedPerSec = 100;

static const CGFloat kScreenRatioMagnifier = 0.5; // Increase sprite size by this ratio to match tilemap

// Time in seconds between texture changes for animations
static const NSTimeInterval kAnimationFramerate = 0.15;

static NSString *const kCharacterActionKey = @"CharacterNodeAction";

- (instancetype)init
{
    if (self = [super initWithImageNamed:@"SD"])
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

/**
 Update position of sprite with delta time
 
 @param deltaTime time in seconds between frames
 */
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

#pragma mark - Properties

- (SKAction *)stillLeftAction
{
    if (!_stillLeftAction)
    {
        SKTexture *t = [SKTexture textureWithImageNamed:@"SL"];
        _stillLeftAction = [SKAction setTexture:t resize:NO];
    }
    
    return _stillLeftAction;
}

- (SKAction *)stillUpAction
{
    if (!_stillUpAction)
    {
        SKTexture *t = [SKTexture textureWithImageNamed:@"SU"];
        _stillUpAction = [SKAction setTexture:t resize:NO];
    }
    
    return _stillUpAction;
}

- (SKAction *)stillRightAction
{
    if (!_stillRightAction)
    {
        SKTexture *t = [SKTexture textureWithImageNamed:@"SR"];
        _stillRightAction = [SKAction setTexture:t resize:NO];
    }
    
    return _stillRightAction;
}

- (SKAction *)stillDownAction
{
    if (!_stillDownAction)
    {
        SKTexture *t = [SKTexture textureWithImageNamed:@"SD"];
        _stillDownAction = [SKAction setTexture:t resize:NO];
    }
    
    return _stillDownAction;
}



- (SKAction *)movingLeftAction
{
    if (!_movingLeftAction)
    {
        SKTexture *t0 = [SKTexture textureWithImageNamed:@"WL0"];
        SKTexture *t1 = [SKTexture textureWithImageNamed:@"WL1"];
        SKTexture *t2 = [SKTexture textureWithImageNamed:@"WL2"];
        
        SKAction *repeatingAction = [SKAction animateWithTextures:@[t0, t1, t2, t1]
                                                     timePerFrame:kAnimationFramerate];
        _movingLeftAction = [SKAction repeatActionForever:repeatingAction];
    }
    
    return _movingLeftAction;
}

- (SKAction *)movingUpAction
{
    if (!_movingUpAction)
    {
        SKTexture *t0 = [SKTexture textureWithImageNamed:@"WU0"];
        SKTexture *t1 = [SKTexture textureWithImageNamed:@"WU1"];
        SKTexture *t2 = [SKTexture textureWithImageNamed:@"WU2"];
        
        SKAction *repeatingAction = [SKAction animateWithTextures:@[t0, t1, t2, t1]
                                                     timePerFrame:kAnimationFramerate];
        _movingUpAction = [SKAction repeatActionForever:repeatingAction];
    }
    
    return _movingUpAction;
}

- (SKAction *)movingRightAction
{
    if (!_movingRightAction)
    {
        SKTexture *t0 = [SKTexture textureWithImageNamed:@"WR0"];
        SKTexture *t1 = [SKTexture textureWithImageNamed:@"WR1"];
        SKTexture *t2 = [SKTexture textureWithImageNamed:@"WR2"];
        
        
        SKAction *repeatingAction = [SKAction animateWithTextures:@[t0, t1, t2, t1]
                                                     timePerFrame:kAnimationFramerate];
        _movingRightAction = [SKAction repeatActionForever:repeatingAction];
        
    }
    
    return _movingRightAction;
}

- (SKAction *)movingDownAction
{
    if (!_movingDownAction)
    {
        SKTexture *t0 = [SKTexture textureWithImageNamed:@"WD0"];
        SKTexture *t1 = [SKTexture textureWithImageNamed:@"WD1"];
        SKTexture *t2 = [SKTexture textureWithImageNamed:@"WD2"];
        
        SKAction *repeatingAction = [SKAction animateWithTextures:@[t0, t1, t2, t1]
                                                     timePerFrame:kAnimationFramerate];
        _movingDownAction = [SKAction repeatActionForever:repeatingAction];
    }
    
    return _movingDownAction;
}


@end
