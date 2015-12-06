//
//  GameScene.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/5/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "GameScene.h"
#import "JSTileMap.h"
#import "CharacterNode.h"

@interface GameScene ()

/**
 Holds TMX file representation, SKNode for world
 */
@property (nonatomic, strong) JSTileMap *tileMapNode;

@property (nonatomic, strong) CharacterNode *characterNode;

@end

//-------------------------------------------------

@implementation GameScene

static NSString *const kTMXFileName = @"PokeMap.tmx";

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.anchorPoint = CGPointMake(0.5,0.5);
        self.scaleMode = SKSceneScaleModeAspectFill;
        
        [self addChild:self.tileMapNode];
        [self addChild:self.characterNode];
    }

    return self;
}

#pragma mark - Properties

- (JSTileMap *)tileMapNode
{
    if (!_tileMapNode)
    {
        _tileMapNode = [JSTileMap mapNamed:kTMXFileName];

        CGFloat screenScale = [[UIScreen mainScreen] scale];
        _tileMapNode.xScale = screenScale;
        _tileMapNode.yScale = screenScale;
        
        
        /*   TODO: replace with appropriate start position indicated by TMX   */
        /*   center map   */
        CGRect mapBounds = [_tileMapNode calculateAccumulatedFrame];
        _tileMapNode.position = CGPointMake(-mapBounds.size.width/2.0,
                                            -mapBounds.size.height/2.0);
    }
    
    return _tileMapNode;
}

- (CharacterNode *)characterNode
{
    if (!_characterNode)
    {
        _characterNode = [[CharacterNode alloc] init];
        
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        [_characterNode setScreenScale:screenScale];
        
        // TODO: Place appropriately

    }
    
    return _characterNode;
}

#pragma mark - SKScene

- (void)update:(NSTimeInterval)currentTime
{
    // STUB
}

- (void)didEvaluateActions
{
    // STUB
}

- (void)didSimulatePhysics
{
    // STUB: Probably don't need this, depending on game design
}

- (void)didFinishUpdate
{
    // STUB
}

#pragma mark - GameControlViewDelegate

- (void)gameControlDidChangeToState:(GameControlViewState)state
{
    CharacterNodeState charState;
    
    if (state == GameControlViewStateNoPress)
        charState = CharacterNodeStateStill;
    else if (state == GameControlViewStateLeftPress)
        charState = CharacterNodeStateMovingLeft;
    else if (state == GameControlViewStateUpPress)
        charState = CharacterNodeStateMovingUp;
    else if (state == GameControlViewStateRightPress)
        charState = CharacterNodeStateMovingRight;
    else if (state == GameControlViewStateDownPress)
        charState = CharacterNodeStateMovingDown;
    
    [self.characterNode setState:charState];
}

- (void)gameControlDidPressAction
{
    // TODO: STUB
}



@end
