//
//  EventSequence.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventProtocol.h"

/**
 Represents a sequence of Events, tied to a specific scene identifier
 Encapsulates FIFO queue of events executed sequentially
 */
@interface EventSequence : NSObject

/// Unique identifier for this EventSeqence (i.e. a scene name)
@property (nonatomic, readonly, copy) NSString *sceneId;

/**
 Initialize new EventSequence with sceneId
 
 @param sceneId NSString of scene's name
 
 @return new EventSequence
 */
- (instancetype)initWithSceneId:(NSString *)sceneId;


/**
 Append event to sequence of events.
 
 @param event Obj conforming to EventProtocol to add to sequence of events
 */
- (void)appendEvent:(id<EventProtocol>)event;


/**
 Retrieve next event in sequence and move forward in the sequence.
 
 @return next event in sequence, or nil if there are no more events
 */
- (id<EventProtocol>)nextEvent;

/**
 Rewinds to beginning of an event sequence.
 First event in sequence is provided next time nextEvent: is called
 */
- (void)rewindToBeginning;

@end
