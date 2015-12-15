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
#import "DialogueEvent.h"
#import "FlagToggleEvent.h"
#import "ChoiceEvent.h"
#import "SpecialEvent.h"

#define STORY_LOG

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

static NSString *const kSaveFileName = @"ltg-save.dat";

NSString *const StoryStoreSpecialEventSuccess   = @"specialeventsuccess";
NSString *const StoryStoreSpecialEventFail      = @"specialeventfailure";

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
    BOOL hasActiveSequence = self.activeSequence != nil && !self.activeSequence.isDone;
    BOOL hasActiveEvent = self.currentEvent != nil;
    
    return hasActiveEvent || hasActiveSequence;
}

- (void)activateEventSequenceForId:(NSString *)characterIdentifier
{
    EntityInteractionGroup *interactionGroup = self.interactionGroups[characterIdentifier];
    
    if (!interactionGroup)
        NSLog(@"%@: Couldn't find sequence for entity id %@", NSStringFromClass([self class]), characterIdentifier);
    
    self.activeSequence = [interactionGroup eventSequenceForFlags:self.gameState];
    [self.activeSequence rewindToBeginning];
    self.currentEvent = nil;
    
#ifdef STORY_LOG
    NSLog(@"Activated scene %@", self.activeSequence.sceneId);
#endif
    
    if (self.activeSequence)
        [self progressToNextEventWithOption:nil];
}

- (void)cancelActiveEventSequence
{
#ifdef STORY_LOG
    NSLog(@"Cancel: %@", self.currentEvent);
#endif
    
    self.activeSequence = nil;
    self.currentEvent = nil;
}

- (void)progressToNextEventWithOption:(NSString *)option
{
    assert(self.activeSequence);
    
    /// Event type of current, or next event
    EventType type = EventTypeNone;

    /*   Redirect if current event prompts further interactions   */
    if (self.currentEvent)
    {
        /// Scene to jump to, depending on user interaction (e.g. choice selection, event completion)
        NSString *destSceneId = nil;
        
        type = [self.currentEvent eventType];
        
        /*   Find which scene to jump to depending on event type and interaction   */
        if (type == EventTypeChoice)
        {
            ChoiceEvent *choiceEvent = (ChoiceEvent *)self.currentEvent;
            destSceneId = [choiceEvent destinationSceneForChoiceOption:option];
            
#ifdef STORY_LOG
            NSLog(@"Chose: %@", option);
#endif
        }
        else if (type == EventTypeSpecial)
        {
            SpecialEvent *specialEvent = (SpecialEvent *)self.currentEvent;
            
            if ([option isEqualToString:StoryStoreSpecialEventSuccess])
            {
                destSceneId = specialEvent.onSuccessSceneId;
            }
            else if ([option isEqualToString:StoryStoreSpecialEventFail])
            {
                destSceneId = specialEvent.onFailureSceneId;
            }
            else
            {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                               reason:@"Invalid option in response to active SpecialEvent"
                                             userInfo:nil];
            }
        }
        
        
        /*   Clear current event, as it was handled   */
        self.currentEvent = nil;
        
        /*   Jump to destination scene and interrupt current active event sequence, if any   */
        if (destSceneId)
        {
            [self jumpToScene:destSceneId];
            return;
        }
    }

    
    
    /*   Move Forward in story   */
    while (![self.activeSequence isDone])
    {
        self.currentEvent = self.activeSequence.nextEvent;
        
        type = [self.currentEvent eventType];
        
        if (type == EventTypeDialogue ||
            type == EventTypeChoice ||
            type == EventTypeSpecial)
        {
            // Dialogue, Choice, and Special events notify delegate
            [self.delegate storyStoreReadEvent:self.currentEvent];
            
#ifdef STORY_LOG
            NSLog(@"Read: %@", self.currentEvent);
#endif
            
            break;
        }
        else if (type == EventTypeFlagToggle)
        {
            // Flag events silently update game state
            FlagToggleEvent *flagEvent = (FlagToggleEvent *)self.currentEvent;
            flagEvent.raised = YES;
            
            // Don't hold onto flag change events
            self.currentEvent = nil;
            
#ifdef STORY_LOG
            NSLog(@"Completed: %@", flagEvent.flagIdentifier);
#endif
            
            [self.gameState addObject:flagEvent.flagIdentifier];
        }
        else
        {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Unhandled event type"
                                         userInfo:nil];
        }
    }
    
    
    /*   Sequence has been exhaused - no more events    */
    if (self.currentEvent == nil)
    {
        [self.delegate storyStoreFinishedSequence];
        
#ifdef STORY_LOG
        NSLog(@"Ended sequence");
#endif
    }
    

}

#pragma mark - Private

/**
 Jump to scene with specified sceneId, interrupting current active eventSequence if any
 */
- (void)jumpToScene:(NSString *)sceneId
{
#ifdef STORY_LOG
    NSLog(@"Jump to scene: %@", sceneId);
#endif
    
    self.activeSequence = self.eventSequences[sceneId];
    [self.activeSequence rewindToBeginning];
    self.currentEvent = nil;

    [self progressToNextEventWithOption:nil];
}

/**
 Load save file from documents directory, if such file exists
 */
- (void)loadSaveFile
{
    // TODO: stub
}

/**
 Path to save file in Documents directory
 
 @return NSString path to save file
 */
- (NSString *)saveFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    return [documentsDirectory stringByAppendingPathComponent:kSaveFileName];
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
