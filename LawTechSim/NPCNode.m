//
//  NPCNode.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/14/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "NPCNode.h"

@implementation NPCNode

static NSString *const kStandbyActionKey = @"NPCStandby";

static const CGFloat kNPCCollisionRectHeightInset = -5;

#pragma mark - Public

/// Runs repeating action once assigned
- (void)setStandbyAction:(SKAction *)standbyAction
{
    _standbyAction = standbyAction;
    
    // Add new action
    if (!self.interacting)
        [self runAction:[SKAction repeatActionForever:standbyAction]
                withKey:kStandbyActionKey];
}

/// Pauses repeating action while Interactiong = YES
- (void)setInteracting:(BOOL)interacting
{
    _interacting = interacting;
    
    if (_interacting)
    {
        [self runAction:[SKAction repeatActionForever:self.standbyAction]
                withKey:kStandbyActionKey];
    }
    else
    {
        [self removeActionForKey:kStandbyActionKey];
    }
}

#pragma mark - EntityNode

// Collision rect for NPC is little bigger for some space
- (CGRect)collisionRect
{
    return CGRectInset([super collisionRect], 0, kNPCCollisionRectHeightInset);
}


@end
