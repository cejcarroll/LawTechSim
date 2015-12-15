//
//  NPCNode.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/14/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "EntityNode.h"

/**
 NPCNodes are EntityNodes + Repeating Animation actions
 */
@interface NPCNode : EntityNode

/// Action repeated forever when NPCNode is not interacted with
@property (nonatomic, strong) SKAction *standbyAction;

/// Flag to indicate that user is interacting with this NPC. Initially NO
@property (nonatomic, assign) BOOL interacting;

@end
