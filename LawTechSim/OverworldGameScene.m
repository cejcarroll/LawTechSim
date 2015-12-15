//
//  GameScene.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/5/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "OverworldGameScene.h"
#import "JSTileMap.h"
#import "CharacterNode.h"
#import "NPCNode.h"

//#define COLLISION_DEBUG

@interface OverworldGameScene ()

/// Adjusts viewport of scene
@property (nonatomic, strong) SKCameraNode *cameraNode;

/// Holds TMX file representation, SKNode for world
@property (nonatomic, strong) JSTileMap *tileMapNode;

/// Representation of user character in screen
@property (nonatomic, strong) CharacterNode *characterNode;

/// Array of all NPC Nodes
@property (nonatomic, strong) NSArray <NPCNode *> *npcNodes;

/// Representation of NPC Brad
@property (nonatomic, strong) NPCNode *bradNode;

/// Representation of NPC Emily
@property (nonatomic, strong) NPCNode *emilyNode;

/// Representation of NPC Sei
@property (nonatomic, strong) NPCNode *seiNode;

/// Last time update: was called in game loop
@property (nonatomic, assign) NSTimeInterval lastUpdateTimeInterval;

#ifdef COLLISION_DEBUG
/// Show where the collision box is
@property (nonatomic, strong) SKSpriteNode *collisionBoxNode;
@property (nonatomic, strong) NSMutableArray *collisionMarkers;
#endif

@end

//-------------------------------------------------

@implementation OverworldGameScene

/*   TMX Constants   */
static NSString *const kTMXFileName             = @"tilemap.tmx";
static NSString *const kCollisionLayer          = @"collisions";
static NSString *const kLocationObjLayer        = @"locations";
static NSString *const kLocationObjCharacterPos = @"characterLocation";
static NSString *const kLocationObjNPCBradPos   = @"npcBradLocation";
static NSString *const kLocationObjNPCSeiPos    = @"npcSeiLocation";
static NSString *const kLocationObjNPCEmilyPos  = @"npcEmilyLocation";

/*   NPC Constants   */
static NSString *const kBradEntityId            = @"Brad";
static NSString *const kSeiEntityId             = @"Sei";
static NSString *const kEmilyEntityId           = @"Emily";


/// Character's zPosition
static const CGFloat kCharacterZPosition = -35;

/// NPC'z zPosition when in front of character
static const CGFloat kNPCZPositionForeground = -20;

/// NPC's zPosition when behind character
static const CGFloat kNPCZPositionBackground = -40;

/// Space between zPosition of layers
static const CGFloat kTileMapLayerDistance = -10;

/// Extra padding on collision to prevent being stuck on walls
static const CGFloat kCollisionPadding = 0.5;

/// Distance required to be considered "nearby"
static const CGFloat kNearbyThresholdDistance = 25;

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.anchorPoint = CGPointMake(0.5,0.5);
        self.scaleMode = SKSceneScaleModeAspectFill;
        
        _lastUpdateTimeInterval = 0;
        
        /*   Setup world nodes   */
        [self addChild:self.cameraNode];
        [self addChild:self.tileMapNode];
        
        
        /*   Setup Entity nodes   */
        [self addChild:self.bradNode];
        [self addChild:self.seiNode];
        [self addChild:self.emilyNode];
        
        [self addChild:self.characterNode];
        
        
#ifdef COLLISION_DEBUG
        self.collisionBoxNode = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeZero];
        
        self.collisionBoxNode.zPosition = kCharacterZPosition + 1; // right below character
        [self addChild:self.collisionBoxNode];
        
        self.collisionMarkers = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < 4; i++)
        {
            SKSpriteNode *n = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeZero];
            n.zPosition = kCharacterZPosition + 1;
            [self.collisionMarkers addObject:n];
            [self.tileMapNode addChild:n];
        }
#endif
    }
    
    return self;
}

#pragma mark - Public

- (void)redirectGameInput:(GameControlViewState)state
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

- (NSString *)nearbyEntityForCharacter
{
    CGFloat closestDist = CGFLOAT_MAX;
    NPCNode *nearbyNPCNode = nil;
    
    for (NPCNode *npcNode in self.npcNodes)
    {
        CGFloat dist = [self distanceBetweenPoint:self.characterNode.position
                                          toPoint:npcNode.position];
        
        if (dist < closestDist)
        {
            closestDist = dist;
            nearbyNPCNode = npcNode;
        }
    }
    
    if (closestDist < kNearbyThresholdDistance)
    {
        return nearbyNPCNode.entityId;
    }
    else
    {
        return nil;
    }
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
        
        [self positionNode:_characterNode atLocationObj:kLocationObjCharacterPos];
    }
    
    return _characterNode;
}

- (NSArray <NPCNode *> *)npcNodes
{
    if (!_npcNodes)
    {
        _npcNodes = @[self.bradNode, self.emilyNode, self.seiNode];
    }
    
    return _npcNodes;
}

- (NPCNode *)bradNode
{
    if (!_bradNode)
    {
        _bradNode = [[NPCNode alloc] initWithEntityId:kBradEntityId];
        _bradNode.zPosition = kNPCZPositionBackground;
        [self positionNode:_bradNode atLocationObj:kLocationObjNPCBradPos];
    }
    
    return _bradNode;
}

- (NPCNode *)seiNode
{
    if (!_seiNode)
    {
        _seiNode = [[NPCNode alloc] initWithEntityId:kSeiEntityId];
        _seiNode.zPosition = kNPCZPositionBackground;
        [self positionNode:_seiNode atLocationObj:kLocationObjNPCSeiPos];
    }
    
    return _seiNode;
}

- (NPCNode *)emilyNode
{
    if (!_emilyNode)
    {
        _emilyNode = [[NPCNode alloc] initWithEntityId:kEmilyEntityId];
        _emilyNode.zPosition = kNPCZPositionBackground;
        [self positionNode:_emilyNode atLocationObj:kLocationObjNPCEmilyPos];
    }
    
    return _emilyNode;
}

#pragma mark - SKScene

- (void)update:(NSTimeInterval)currentTime
{
    /*   Calculate time b/t frames   */
    CGFloat deltaTime = self.lastUpdateTimeInterval - currentTime;
    self.lastUpdateTimeInterval = currentTime;
    if (deltaTime > 0.02) // Cap diff
        deltaTime = 0.02;
    
    /*   Update character position   */
    [self.characterNode updatePositionWithTimeInterval:deltaTime];
    
    
    // FIXME: Refactor collision code
    
    /*   Resolve collisions   */
    static TMXLayer *collisionLayer = nil;
    
    if (!collisionLayer)
        collisionLayer = [self.tileMapNode layerNamed:kCollisionLayer];
    
    NSArray <SKSpriteNode *> *collisionTiles = [self tileNodesForCollisionWithLayer:collisionLayer];
    
    if (collisionTiles.count > 0)
    {
        CGRect relativeCharFrame = self.characterNode.collisionRect;
        CGRect tileMapSize = [self.tileMapNode calculateAccumulatedFrame];
        relativeCharFrame.origin.x += (tileMapSize.size.width / 2) - (relativeCharFrame.size.width / 2);
        relativeCharFrame.origin.y += (tileMapSize.size.height / 2) - (relativeCharFrame.size.height / 2);
        
        for (SKSpriteNode *tile in collisionTiles)
        {
            CGRect tileCollisionIntersection = CGRectIntersection(relativeCharFrame, tile.frame);
            [self adjustCharacterNodeWithCollisionRect:tileCollisionIntersection];
        }
        
    }
    
#ifdef COLLISION_DEBUG
    [self updateCollisionDebugViews:collisionTiles];
#endif
    
    /*   Resolve NPC zPositions and collisions   */
    CGRect npcCollisionIntersection = CGRectNull;
    
    for (NPCNode *npcNode in self.npcNodes)
    {
        [self adjustZPositionForNPCNode:npcNode];
        npcCollisionIntersection = CGRectIntersection(self.characterNode.collisionRect, npcNode.collisionRect);
        [self adjustCharacterNodeWithCollisionRect:npcCollisionIntersection];
    }
}

- (void)didFinishUpdate
{
    /*   Update camera centered on user   */
    [self.cameraNode setPosition:self.characterNode.position];
}

#pragma mark - Private

// FIXME: Consider moving positionNode:atLocationObj to JSTileMap extension
/**
 Position node at a specified location within "location" object layer of tmx file
 
 @param node SKNode to position at location
 @param objName name of object within location layer
 */
- (void)positionNode:(SKNode *)node atLocationObj:(NSString *)objName
{
    TMXObjectGroup *locationGroup = [self.tileMapNode groupNamed:kLocationObjLayer];
    NSDictionary *loc = [locationGroup objectNamed:objName];
    
    if (loc)
    {
        CGFloat xPos = [(NSNumber *)loc[@"x"] doubleValue];
        CGFloat yPos = [(NSNumber *)loc[@"y"] doubleValue];
        CGPoint charPoint = CGPointMake(xPos, yPos);
        charPoint.x += self.tileMapNode.position.x;
        charPoint.y += self.tileMapNode.position.y;
        node.position = charPoint;
    }
}


/**
 Get all coordinates to check for collision based on character's current location
 Based off the four corners of characterNode's collision box
 
 @param layer TMXLayer to check against
 
 @return array of 3 CGPoint of tile coordinates to check as NSValues
 */
- (NSArray <NSValue *> *)coordinatesForCollisionWithLayer:(TMXLayer *)layer
{
    CGPoint topLeftCoord, topRightCoord, botLeftCoord, botRightCoord;
    
    CGRect charLocBox = self.characterNode.collisionRect;
    charLocBox.origin = [self convertPoint:charLocBox.origin toNode:self.tileMapNode];
    
    CGFloat deltaX = charLocBox.size.width / 2;
    CGFloat deltaY = charLocBox.size.height / 2;
    
    // FIXME: SpriteKit coordinates are weird. Not too sure if I'm re-converting things
    
    // Top Left
    topLeftCoord = [layer coordForPoint:CGPointMake(charLocBox.origin.x - deltaX,
                                                    charLocBox.origin.y + deltaY)];
    
    // Top Right
    topRightCoord = [layer coordForPoint:CGPointMake(charLocBox.origin.x + deltaX,
                                                     charLocBox.origin.y + deltaY)];
    
    // Bottom Left
    botLeftCoord = [layer coordForPoint:CGPointMake(charLocBox.origin.x - deltaX,
                                                    charLocBox.origin.y - deltaY)];
    
    // Bottom Right
    botRightCoord = [layer coordForPoint:CGPointMake(charLocBox.origin.x + deltaX,
                                                     charLocBox.origin.y - deltaY)];
    
    if (self.characterNode.state == CharacterNodeStateMovingLeft)
    {
        return @[[NSValue valueWithCGPoint:topLeftCoord],
                 [NSValue valueWithCGPoint:botLeftCoord]];
    }
    else if (self.characterNode.state == CharacterNodeStateMovingUp)
    {
        return @[[NSValue valueWithCGPoint:topLeftCoord],
                 [NSValue valueWithCGPoint:topRightCoord]];
    }
    else if (self.characterNode.state == CharacterNodeStateMovingRight)
    {
        return @[[NSValue valueWithCGPoint:topRightCoord],
                 [NSValue valueWithCGPoint:botRightCoord]];
    }
    else if (self.characterNode.state == CharacterNodeStateMovingDown)
    {
        
        return @[[NSValue valueWithCGPoint:botLeftCoord],
                 [NSValue valueWithCGPoint:botRightCoord]];
    }
    else
    {
        return @[];
    }
}


/**
 Get tiles against which character's collision should be checked.
 
 @param layer TMXLayer with tiles to check collision against
 
 @return Array of max 3 tile's SKNodes
 */
- (NSArray <SKSpriteNode *> *)tileNodesForCollisionWithLayer:(TMXLayer *)layer
{
    NSArray *coordinates = [self coordinatesForCollisionWithLayer:layer];
    NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:3];
    
    for (NSValue *v in coordinates)
    {
        CGPoint coord = [v CGPointValue];
        SKSpriteNode *tile = [layer tileAtCoord:coord];
        
        // If tile exists within possible coordinates to collide with...
        if (tile)
            [nodes addObject:tile];
    }
    
    return nodes;
}


/**
 Adjust position of character node based on tile collision rect and current orientation
 @param intersectionRect CGRect intersection against tile
 */
- (void)adjustCharacterNodeWithCollisionRect:(CGRect)intersectionRect
{
    if (CGRectIsNull(intersectionRect))
        return;
    
    CGPoint newPos = self.characterNode.position;
    
    // NOTE: kCollisionPadding gives some space to prevent getting stuck along walls / in corners
    
    if (self.characterNode.state == CharacterNodeStateMovingLeft)
    {
        newPos.x += intersectionRect.size.width + kCollisionPadding;
    }
    else if (self.characterNode.state == CharacterNodeStateMovingUp)
    {
        newPos.y -= intersectionRect.size.height + kCollisionPadding;
    }
    else if (self.characterNode.state == CharacterNodeStateMovingRight)
    {
        newPos.x -= intersectionRect.size.width + kCollisionPadding;
    }
    else if (self.characterNode.state == CharacterNodeStateMovingDown)
    {
        newPos.y += intersectionRect.size.height + kCollisionPadding;
    }
    
    [self.characterNode setState:CharacterNodeStateStill];
    [self.characterNode setPosition:newPos];
    
}

/**
 Change zPosition of NPCNodes depending on characterNode's yPosition
 Only changes value if npcNode is displayed within cameraNode's viewport
 */
- (void)adjustZPositionForNPCNode:(NPCNode *)npcNode;
{
    if (![self.cameraNode containsNode:npcNode])
        return;
    
    if (npcNode.position.y < self.characterNode.position.y)
        npcNode.zPosition = kNPCZPositionForeground;
    else
        npcNode.zPosition = kNPCZPositionBackground;
}

/**
 Returns distance between two points
 //FIXME: Should move elsewhere
 
 @param p1 CGPoint first point
 @param p2 CGPoint second point
 
 @return CGFloat distance between points
 */
- (CGFloat)distanceBetweenPoint:(CGPoint)p1 toPoint:(CGPoint)p2
{
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
}


#ifdef COLLISION_DEBUG
/**
 Given array of SKSpriteNode of tiles in timeMap, highlights them.
 
 @param collisionTiles tiles that characters hit box collided with
 */
- (void)updateCollisionDebugViews:(NSArray <SKSpriteNode *> *)collisionTiles
{
    // update character marker
    CGRect charLoc = self.characterNode.collisionRect;
    self.collisionBoxNode.position = charLoc.origin;
    self.collisionBoxNode.size = charLoc.size;
    
    
    // reset markers
    for (SKSpriteNode *n in self.collisionMarkers)
        n.size = CGSizeZero;
    
    // place markers
    for (int i = 0; i < collisionTiles.count; i++)
    {
        SKSpriteNode *t = collisionTiles[i];
        SKSpriteNode *n = self.collisionMarkers[i];
        
        n.position = t.position;
        n.size = t.size;
    }
}
#endif

@end
