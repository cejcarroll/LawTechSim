//
//  EventSequenceGroup.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EventSequence;

/**
 A collection of EventSequence objects corresponding to a single entity
 e.g. All possible interactions for a specific character / thing in game
 */
@interface EntityInteractionGroup : NSObject

/// Id of assotiated entity, e.g. a NPC's identifier
@property (nonatomic, readonly, copy) NSString *entityId;

/**
 Initialize new EntityInteractionGroup assotiated to entity
 
 @param entityId NSString id of entity to be associated with
 
 @return new EntityInteractionGroup
 */
- (instancetype)initWithEntityId:(NSString *)entityId;

/**
 Add an EventSequence to group. Note that later-added sequence have less priority, 
 and are evaluated later on.
 
 // TODO: Add priority to sequences?
 
 @param sequence EventSequence to add
 */
- (void)addEventSequence:(EventSequence *)sequence;


/**
 Fetch eventSequence satisfying current game state
 
 @param flags NSArray of identifiers for currently raised flags
 
 @return corresponding EventSequence for state
 */
- (EventSequence *)eventSequenceForFlags:(NSSet <NSString *> *)state;

@end
