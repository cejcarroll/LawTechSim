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

#define COLLISION_DEBUG

@interface GameScene ()

/// Adjusts viewport of scene
@property (nonatomic, strong) SKCameraNode *cameraNode;

/// Holds TMX file representation, SKNode for world
@property (nonatomic, strong) JSTileMap *tileMapNode;

/// Representation of user character in screen
@property (nonatomic, strong) CharacterNode *characterNode;

/// Last time update: was called in game loop
@property (nonatomic, assign) NSTimeInterval lastUpdateTimeInterval;

#ifdef COLLISION_DEBUG
/// Show where the collision box is
@property (nonatomic, strong) SKSpriteNode *collisionBoxNode;
#endif

@end

//-------------------------------------------------

@implementation GameScene

// TMX Constants
static NSString *const kTMXFileName             = @"tilemap.tmx";
static NSString *const kLocationObjLayer        = @"locations";
static NSString *const kLocationObjCharacterPos = @"characterLocation";
static NSString *const kLocationObjNPCBradPos   = @"npcBradLocation";

static const CGFloat kCharacterZPosition = -35;
static const CGFloat kTileMapLayerDistance = -10;

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.anchorPoint = CGPointMake(0.5,0.5);
        self.scaleMode = SKSceneScaleModeAspectFill;
        
        _lastUpdateTimeInterval = 0;
        
        [self addChild:self.cameraNode];
        [self addChild:self.tileMapNode];
        [self addChild:self.characterNode];
        
#ifdef COLLISION_DEBUG
        self.collisionBoxNode = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeZero];
        self.collisionBoxNode.zPosition = kCharacterZPosition - 1; // right below character
        [self addChild:self.collisionBoxNode];
#endif
    }

    return self;
}

#pragma mark - Properties

- (SKCameraNode *)cameraNode
{
    if (!_cameraNode)
    {
        self.cameraNode = [SKCameraNode node];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        [self.cameraNode setScale:1.0 / screenScale];
        self.camera = self.cameraNode;
    }
    
    return _cameraNode;
}

- (JSTileMap *)tileMapNode
{
    if (!_tileMapNode)
    {
        _tileMapNode = [JSTileMap mapNamed:kTMXFileName
                         withBaseZPosition:0
                         andZOrderModifier:kTileMapLayerDistance];
        
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
        _characterNode.zPosition = kCharacterZPosition;
        
        // TODO: Place appropriately
    }
    
    return _characterNode;
}

#pragma mark - SKScene

- (void)update:(NSTimeInterval)currentTime
{
    /*   Calculate time b/t frames   */
    CGFloat deltaTime = self.lastUpdateTimeInterval - currentTime;
    self.lastUpdateTimeInterval = currentTime;
    
    // Cap time diff
    if (deltaTime > 0.02)
        deltaTime = 0.02;
    
    /*   Update character's position   */
    [self.characterNode updatePositionWithTimeInterval:deltaTime];
    

    // TODO: Detect collisions
    
}


- (void)didFinishUpdate
{
    /*   Update camera centered on user   */
    [self.cameraNode setPosition:self.characterNode.position];

    /*   Prevent movement from collisions   */
    
#ifdef COLLISION_DEBUG
    CGRect collisionRect = self.characterNode.collisionFrame;
    self.collisionBoxNode.position = collisionRect.origin;
    self.collisionBoxNode.size = collisionRect.size;
#endif
    
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
