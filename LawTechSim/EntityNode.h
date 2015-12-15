//
//  EntityNode.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/9/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


/**
 Encapsulates an SKNode with 12 assotiated textures based on entityId.
 Note: Each sprite should be 64x64 ish size. Sizes down by factor of 2 for sharpness on retina
 */
@interface EntityNode : SKSpriteNode

/// Identifier for particular set of sprites, e.g. Main, Brad, or Sei.
@property (nonatomic, copy) NSString *entityId;

// Still Textures
@property (nonatomic, strong) SKTexture *stlLeftTexture;
@property (nonatomic, strong) SKTexture *stlUpTexture;
@property (nonatomic, strong) SKTexture *stlRightTexture;
@property (nonatomic, strong) SKTexture *stlDownTexture;

// Moving Textures
@property (nonatomic, strong) SKTexture *movLeft0Texture;
@property (nonatomic, strong) SKTexture *movLeft1Texture;
@property (nonatomic, strong) SKTexture *movUp0Texture;
@property (nonatomic, strong) SKTexture *movUp1Texture;
@property (nonatomic, strong) SKTexture *movRight0Texture;
@property (nonatomic, strong) SKTexture *movRight1Texture;
@property (nonatomic, strong) SKTexture *movDown0Texture;
@property (nonatomic, strong) SKTexture *movDown1Texture;


/**
 Initialize a new EntityNode with id
 
 @param entityId identifier for sprite images
 
 @return new EntityNode
 */
- (instancetype)initWithEntityId:(NSString *)entityId;


/**
 Frame to detect collisions for CharacterNode
 
 @return a CGRect indication the frame's position
 */
- (CGRect)collisionRect;


@end
