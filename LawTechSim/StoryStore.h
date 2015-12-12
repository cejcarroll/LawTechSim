//
//  StoryReader.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventProtocol.h"
#import "StoryParser.h"

@protocol StoryStoreDelegate <NSObject>

/**
 Called when StoryStore reads particular event
 
 @param event EventProtocol object read
 */
- (void)storyStoreReadEvent:(id <EventProtocol>)event;

@end


//-------------------------------------------------

@class EventSequence;

/**
 Store for interacting with game story described in .ltg file
 Manages events, state flags, and components of story content
 */
@interface StoryStore : NSObject <StoryParserDelegate>

@property (nonatomic, weak) id<StoryStoreDelegate> delegate;

/// Specific event that is active in current active EventSequence. Nil if no event is active
@property (nonatomic, readonly, strong) id<EventProtocol> currentEvent;

/**
 Initialize StoryStore with a file
 
 @param fileName NSString filename of story data file
 @param loadState BOOL to indicate if save file should be loaded (if such exists)
 
 @return new StoryReader
 */
- (instancetype)initWithFileNamed:(NSString *)fileName
                         loadSave:(BOOL)loadSave;


/**
 Create a save file in documents directory representing current game state
 Overwrite file if save already exists
 */
- (void)createSaveFile;

/**
 Check whether there is a currently active EventSequence object.
 Use for checking if user input should be redirected to event-related interactions
 */
- (BOOL)hasActiveEventSequence;


/**
 Activate sequence of events for specific character, accounting for state flags raised.
 Begins sequence of callbacks to delegate
 
 @param characterIdentifier NSString identifier of interacted entity
 */
- (void)activateEventSequenceForId:(NSString *)characterIdentifier;


/**
 Cancels the currently active sequence of events
 */
- (void)cancelActiveEventSequence;

/**
 Notify StoryStore that current active event has been dealt with, and StoryStore
 should move to next event. Causes callback to delegate
 I.e. should be called after displaying a dialogue
 Causes callback to delegate
 */
- (void)progressToNextEvent;

/**
 Notify StoryStore that current active event has been interacted with with an option
 I.e. should be called after a Choice option is selected
 Causes callback to delegate
 
 @param option NSString describing interaction
 */
- (void)progressToNextEventWithOption:(NSString *)option;


@end
