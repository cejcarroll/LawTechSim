//
//  GameScene.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/5/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "GameScene.h"
#import "JSTileMap.h"

@interface GameScene ()

/**
 Holds TMX file representation, SKNode for world
 */
@property (nonatomic, strong) JSTileMap *tileMapNode;

@end

//-------------------------------------------------

@implementation GameScene

static NSString *const kTMXFileName = @"PokeMap.tmx";

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.anchorPoint = CGPointMake(0.5,0.5);
        
        [self addChild:self.tileMapNode];
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
    // TODO: STUB
}

- (void)gameControlDidPressAction
{
    // TODO: STUB
}



@end
