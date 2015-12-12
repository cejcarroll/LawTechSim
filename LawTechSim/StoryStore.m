//
//  StoryReader.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "StoryStore.h"
#import "EntityInteractionGroup.h"
#import "EventSequence.h"

@interface StoryStore ()

/// Dictionary of entityId to it's EntityInteractionGroup
@property (nonatomic, copy) NSDictionary <NSString *, EntityInteractionGroup *> *interactionGroups;

/// Dictionary of all eventSequences in sceneId to EventSequence map
@property (nonatomic, copy) NSDictionary <NSString *, EventSequence *> *eventSequences;

/// Representation of game's state, consisting of set of flag identifiers for ones that are raised
@property (nonatomic, strong) NSMutableSet <NSString *> *gameState;

/// Currently activated sequence of events
@property (nonatomic, strong) EventSequence *activeSequence;

/// Current event in activeSequence that is "running"
@property (nonatomic, readwrite, strong) id <EventProtocol> currentEvent;

/// Parser for story file
@property (nonatomic, strong) StoryParser *storyParser;

@end

@implementation StoryStore

- (instancetype)initWithFileNamed:(NSString *)fileName
                         loadSave:(BOOL)loadSave
{
    if (self = [super init])
    {
        _storyParser = [[StoryParser alloc] init];
        _storyParser.delegate = self;
        [_storyParser parseInteractionGroupsFromFileNamed:fileName];
        
        _gameState = [NSMutableSet set];
        
        if (loadSave)
            [self loadSaveFile];
    }
    
    return self;
}


#pragma mark - Public


- (void)createSaveFile
{
    // TODO: stub
}


- (BOOL)hasActiveEventSequence
{
    return !(self.activeSequence == nil);
}

- (void)activateEventSequenceForId:(NSString *)characterIdentifier
{
    EntityInteractionGroup *interactionGroup = self.interactionGroups[characterIdentifier];
    
    if (!interactionGroup)
        NSLog(@"%@: Couldn't find sequence for entity id %@", NSStringFromClass([self class]), characterIdentifier);
    
    self.activeSequence = [interactionGroup eventSequenceForFlags:self.gameState];
    [self.activeSequence rewindToBeginning];
    self.currentEvent = nil;
    
    [self progressToNextEvent];
}

- (void)cancelActiveEventSequence
{
    self.activeSequence = nil;
    self.currentEvent = nil;
}

- (void)progressToNextEvent
{
    // TODO: stub
//    [self.activeSequence nextEvent];
}

- (void)progressToNextEventWithOption:(NSString *)option
{
    // TODO: stub
}

#pragma mark - Private

- (void)loadSaveFile
{
    // TODO: stub
}

# pragma mark - StoryParserDelegate

- (void)storyParserDidParseInteractionGroups:(NSDictionary<NSString *,EntityInteractionGroup *> *)interactionGroupDict
                                      scenes:(NSDictionary<NSString *,EventSequence *> *)scenes
{
    self.interactionGroups = [interactionGroupDict copy];
    self.eventSequences = scenes;
    
    // Dealloc parser
    self.storyParser = nil;
}

@end
