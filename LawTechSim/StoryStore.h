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


/**
 Notifies delegate that StoryStore finished sequence of events
 */
- (void)storyStoreFinishedSequence;

@end


//-------------------------------------------------

@class EventSequence;

/**
 Store for interacting with game story described in .ltg file
 Manages events, state flags, and components of story content
 */
@interface StoryStore : NSObject <StoryParserDelegate>

/// Constant indicating user's success competing an event
extern NSString *const StoryStoreSpecialEventSuccess;

/// Constant indicating user's failure to complete special event
extern NSString *const StoryStoreSpecialEventFail;

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
 Notify StoryStore that current active event has been interacted with with an option.
 Option can be nil, constants like StoryStoreSpecialEventSuccess, or string value indicating choice option

 Causes callback to delegate
 
 @param option NSString describing interaction. Can be nil if unused, e.g. for every event except Choice
 */
- (void)progressToNextEventWithOption:(NSString *)option;


@end
