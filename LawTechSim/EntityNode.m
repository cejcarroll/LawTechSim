//
//  EntityNode.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/9/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "EntityNode.h"

@implementation EntityNode

/// Increase sprite size by this ratio to match tilemap
static const CGFloat kScreenRatioMagnifier = 0.5;

/// Size of collision box. Should be close to tile-size
static const CGSize kCollisionBoxSize = {16, 8};

/// Offset to bring bounding box closer to feet of character
static const CGFloat kCollisionBoxYOffset = 10;

- (instancetype)initWithEntityId:(NSString *)entityId
{
    if (self = [super init])
    {
        _entityId = [entityId copy];
        
        [self setTexture:self.stlDownTexture];
        [self setSize:self.stlDownTexture.size];
        
        [self setScale:kScreenRatioMagnifier];
    }
    
    return self;
}

#pragma mark - Public

- (CGRect)collisionRect
{
    CGRect frame = self.frame;
    
    frame.origin = self.position;
    frame.origin.y -= kCollisionBoxYOffset; // Shift down
    frame.size = kCollisionBoxSize;
    
    return frame;
}

#pragma mark - Properties

- (SKTexture *)stlLeftTexture
{
    if (!_stlLeftTexture)
        _stlLeftTexture = [SKTexture textureWithImageNamed:
                           [self imgNameForEntityWithPostfix:@"SL"]];

        
    return _stlLeftTexture;
}

- (SKTexture *)stlUpTexture
{
    if (!_stlUpTexture)
        _stlUpTexture = [SKTexture textureWithImageNamed:
                         [self imgNameForEntityWithPostfix:@"SU"]];
    
    return _stlUpTexture;
}

- (SKTexture *)stlRightTexture
{
    if (!_stlRightTexture)
        _stlRightTexture = [SKTexture textureWithImageNamed:
                            [self imgNameForEntityWithPostfix:@"SR"]];
    
    return _stlRightTexture;
}

- (SKTexture *)stlDownTexture
{
    if (!_stlDownTexture)
        _stlDownTexture = [SKTexture textureWithImageNamed:
                           [self imgNameForEntityWithPostfix:@"SD"]];
    
    return _stlDownTexture;
}

- (SKTexture *)movLeft0Texture
{
    if (!_movLeft0Texture)
        _movLeft0Texture = [SKTexture textureWithImageNamed:
                            [self imgNameForEntityWithPostfix:@"WL0"]];
    
    return _movLeft0Texture;
}

- (SKTexture *)movLeft1Texture
{
    if (!_movLeft1Texture)
        _movLeft1Texture = [SKTexture textureWithImageNamed:
                            [self imgNameForEntityWithPostfix:@"WL1"]];
    
    return _movLeft1Texture;
}

- (SKTexture *)movUp0Texture
{
    if (!_movUp0Texture)
        _movUp0Texture = [SKTexture textureWithImageNamed:
                          [self imgNameForEntityWithPostfix:@"WU0"]];
    
    return _movUp0Texture;
}

- (SKTexture *)movUp1Texture
{
    if (!_movUp1Texture)
        _movUp1Texture = [SKTexture textureWithImageNamed:
                          [self imgNameForEntityWithPostfix:@"WU1"]];
    
    return _movUp1Texture;
}

- (SKTexture *)movRight0Texture
{
    if (!_movRight0Texture)
        _movRight0Texture = [SKTexture textureWithImageNamed:
                             [self imgNameForEntityWithPostfix:@"WR0"]];
    
    return _movRight0Texture;
}

- (SKTexture *)movRight1Texture
{
    if (!_movRight1Texture)
        _movRight1Texture = [SKTexture textureWithImageNamed:
                             [self imgNameForEntityWithPostfix:@"WR1"]];
    
    return _movRight1Texture;
}

- (SKTexture *)movDown0Texture
{
    if (!_movDown0Texture)
        _movDown0Texture = [SKTexture textureWithImageNamed:
                            [self imgNameForEntityWithPostfix:@"WD0"]];
    
    return _movDown0Texture;
}

- (SKTexture *)movDown1Texture
{
    if (!_movDown1Texture)
        _movDown1Texture = [SKTexture textureWithImageNamed:
                            [self imgNameForEntityWithPostfix:@"WD1"]];
    
    return _movDown1Texture;
}

#pragma mark - Helper

- (NSString *)imgNameForEntityWithPostfix:(NSString *)postfix
{
    return [NSString stringWithFormat:@"%@-%@", self.entityId, postfix];
}

@end
