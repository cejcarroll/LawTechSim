//
//  StoryReader.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "StoryStore.h"

@interface StoryStore ()

@property (nonatomic, readwrite, strong) id<EventProtocol> currentEvent;

@end

@implementation StoryStore

- (instancetype)initWithFileNamed:(NSString *)fileName
                         loadSave:(BOOL)loadState
{
    if (self = [super init])
    {
        // TODO: stub
    }
    
    return self;
}


#pragma mark - StoryStore Public


- (void)createSaveFile
{
    // TODO: stub
}


- (BOOL)hasActiveEventSequence
{
    // TODO: stub
    return NO;
}

- (void)activateEventSequenceForId:(NSString *)characterIdentifier
{
    // TODO: stub
}

- (void)cancelActiveEventSequence
{
    // TODO: stub
}

- (void)progressToNextEvent
{
    // TODO: stub
}

- (void)progressToNextEventWithOption:(NSString *)option
{
    // TODO: stub
}


#pragma mark - StoryStore Private

/**
 Get state of flag for specific flag identifier
 
 @param flagId NSString identifier to specify flag
 
 @return BOOL indicating whether flag is raised or not
 */
- (BOOL)stateForFlagIdentifier:(NSString *)flagId
{
    //TODO: stub
    return NO;
}

@end
