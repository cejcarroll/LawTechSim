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
@property (nonatomic, strong) SKAction *stillDownAction;
@property (nonatomic, strong) SKAction *stillUpAction;
@property (nonatomic, strong) SKAction *movingLeftAction;
@property (nonatomic, strong) SKAction *movingUpAction;
@property (nonatomic, strong) SKAction *movingRightAction;
@property (nonatomic, strong) SKAction *movingDownAction;

@end

@implementation CharacterNode


// TODO: Probably should organize string constants for assets if not too lazy

static const NSUInteger kInitialMovementSpeed = 5;

// Time in seconds between texture changes for animations on different axis
static const NSTimeInterval kHorizontalAnimationFramerate = 0.3;
static const NSTimeInterval kVerticalAnimationFramerate = 0.5;

- (instancetype)init
{
    if (self = [super initWithImageNamed:@"SD"])
    {
        self.state = CharacterNodeStateStill;
        self.movementSpeed = kInitialMovementSpeed;
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
    
    switch (state) {
        case CharacterNodeStateStill:
            if (self.state == CharacterNodeStateMovingUp)
                execAction = self.stillUpAction;
            else
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
    [self runAction:execAction];
}

#pragma mark - Properties

- (SKAction *)stillDownAction
{
    if (!_stillDownAction)
    {
        SKTexture *t = [SKTexture textureWithImageNamed:@"SD"];
        _stillDownAction = [SKAction setTexture:t resize:NO];
    }
    
    return _stillDownAction;
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

- (SKAction *)movingLeftAction
{
    if (!_movingLeftAction)
    {
        SKTexture *t0 = [SKTexture textureWithImageNamed:@"L0"];
        SKTexture *t1 = [SKTexture textureWithImageNamed:@"L1"];
        SKTexture *t2 = [SKTexture textureWithImageNamed:@"L2"];
        
        _movingLeftAction = [SKAction animateWithTextures:@[t0, t1, t2]
                                             timePerFrame:kHorizontalAnimationFramerate];
    }
    
    return _movingLeftAction;
}

- (SKAction *)movingUpAction
{
    if (!_movingUpAction)
    {
        SKTexture *t0 = [SKTexture textureWithImageNamed:@"U0"];
        SKTexture *t1 = [SKTexture textureWithImageNamed:@"U1"];
        
        _movingUpAction = [SKAction animateWithTextures:@[t0, t1]
                                           timePerFrame:kVerticalAnimationFramerate];
    }
    
    return _movingUpAction;
}

- (SKAction *)movingRightAction
{
    if (!_movingRightAction)
    {
        SKTexture *t0 = [SKTexture textureWithImageNamed:@"R0"];
        SKTexture *t1 = [SKTexture textureWithImageNamed:@"R1"];
        SKTexture *t2 = [SKTexture textureWithImageNamed:@"R2"];
        
        _movingRightAction = [SKAction animateWithTextures:@[t0, t1, t2]
                                              timePerFrame:kHorizontalAnimationFramerate];
    }
    
    return _movingRightAction;
}

- (SKAction *)movingDownAction
{
    if (!_movingDownAction)
    {
        SKTexture *t0 = [SKTexture textureWithImageNamed:@"D0"];
        SKTexture *t1 = [SKTexture textureWithImageNamed:@"D1"];
        
        _movingDownAction = [SKAction animateWithTextures:@[t0, t1]
                                             timePerFrame:kVerticalAnimationFramerate];
    }
    
    return _movingDownAction;
}


@end
