//
//  StoryParser.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "StoryParser.h"
#import "EntityInteractionGroup.h"
#import "EventSequence.h"
#import "FlagToggleEvent.h"
#import "DialogueEvent.h"
#import "ChoiceEvent.h"
#import "SpecialEvent.h"

@interface StoryParser ()

//FIXME: should re-evaluate design

/// Current entity to which scenarios are being mapped to. Nil when outside a scenariogroup block
@property (nonatomic, strong) NSString *currentScenarioEntityId;

/// Mapping of entityId to array of sceneIds. For storing scenario elements of scenariogroup block
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableArray <NSString *> *> *scenarioMapping;

/// Dict of scene identifier to required flag identifier. Stores condition of individual scenario elements
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *> *scenarioConditions;

/// Dict of parsed scenes as SceneId to EventSequences
@property (nonatomic, strong) NSMutableDictionary <NSString *, EventSequence *> *eventSequences;

/// Current EventSequence being built. Nil when outside a scene block
@property (nonatomic, strong) EventSequence *currentEventSequence;

/// ChoiceEvent being built. Nil when outside choicegroup block
@property (nonatomic, strong) ChoiceEvent *currentChoiceEvent;

/// parser for game file
@property (nonatomic, strong) NSXMLParser *fileParser;

@end

@implementation StoryParser

static NSString *const kStoryElement                                = @"lawtechstory";

/*   Scenarios   */
static NSString *const kScenarioGroupElement                        = @"scenariogroup";
static NSString *const kScenarioGroupCharacterAttributeKey          = @"character";
static NSString *const kScenarioElement                             = @"scenario";
static NSString *const kScenarioConditionKey                        = @"cond";
static NSString *const kScenarioDestinationSceneKey                 = @"jumpTo";

/*   Scenes   */
static NSString *const kSceneElement                                = @"scene";
static NSString *const kSceneIdKey                                  = @"id";

/*   Events   */
static NSString *const kDialogueEventElement                        = @"dialogue";
static NSString *const kFlagToggleEventElement                      = @"toggle";
static NSString *const kChoiceGroupElement                          = @"choicegroup";
static NSString *const kChoiceElement                               = @"choice";
static NSString *const kSpecialEventElement                         = @"event";


#pragma mark - Public

- (void)parseInteractionGroupsFromFileNamed:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName
                                                     ofType:@"ltg"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    self.scenarioMapping = [NSMutableDictionary dictionary];
    self.scenarioConditions = [NSMutableDictionary dictionary];
    self.eventSequences = [NSMutableDictionary dictionary];
    
    self.fileParser = [[NSXMLParser alloc] initWithData:data];
    self.fileParser.delegate = self;
    [self.fileParser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    /*   Apply condition requirements to EventSequences   */
    for (EventSequence *eS in self.eventSequences.allValues)
    {
        NSString *condition = self.scenarioConditions[eS.sceneId];
        
        if (condition)
            eS.requiredFlagIdentifier = condition;
    }
    
    /// Dictionary of entityId to EntityInteractionGroups
    NSMutableDictionary <NSString *, EntityInteractionGroup *> *interactionGroupDictionary = [[NSMutableDictionary alloc] initWithCapacity:self.scenarioMapping.allKeys.count];
    
    /*   Iterate through all mappings, validate connections between scenario map and sceneIds   */
    for (NSString *entityId in self.scenarioMapping.allKeys)
    {
        EntityInteractionGroup *interactionGroup = [[EntityInteractionGroup alloc] initWithEntityId:entityId];
        interactionGroupDictionary[entityId] = interactionGroup;
        
        /*   For every sceneId mapped for particular entityId   */
        for (NSString *sceneId in self.scenarioMapping[entityId])
        {
            EventSequence *eSToMap = nil;
            
            /*   Check against all parsed event sequences   */
            for (EventSequence *eS in self.eventSequences.allValues)
            {
                if ([eS.sceneId isEqualToString:sceneId])
                {
                    eSToMap = eS;
                    break;
                }
            }
            
            /*   Add EventSequence to interaction group for entity, if such was found   */
            if (eSToMap)
            {
                [interactionGroup addEventSequence:eSToMap];
            }
            else
            {
                NSLog(@"Didn't find mapping for sceneId: %@", sceneId);
            }
        }
    }

    [self.delegate storyParserDidParseInteractionGroups:interactionGroupDictionary
                                                 scenes:self.eventSequences];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    if ([elementName isEqualToString:kScenarioGroupElement])
    {
        self.currentScenarioEntityId = attributeDict[kScenarioGroupCharacterAttributeKey];
        self.scenarioMapping[self.currentScenarioEntityId] = [NSMutableArray array];
    }
    else if ([elementName isEqualToString:kScenarioElement])
    {
        assert(self.currentScenarioEntityId);
        
        NSString *destSceneId = attributeDict[kScenarioDestinationSceneKey];
        NSString *condition = attributeDict[kScenarioConditionKey];
        
        // Pair scene with entity id
        [self.scenarioMapping[self.currentScenarioEntityId] addObject:destSceneId];
        
        // Associate scene with condition if there is one
        if (condition)
            self.scenarioConditions[destSceneId] = condition;
    }
    else if ([elementName isEqualToString:kSceneElement])
    {
        NSString *sceneId = attributeDict[kSceneIdKey];
        assert(sceneId);

        self.currentEventSequence = [[EventSequence alloc] initWithSceneId:sceneId];
    }
    else if ([elementName isEqualToString:kDialogueEventElement])
    {
        assert(self.currentEventSequence);
        DialogueEvent *dialogueEvent = [[DialogueEvent alloc] initWithAttributes:attributeDict];
        [self.currentEventSequence appendEvent:dialogueEvent];
    }
    else if ([elementName isEqualToString:kChoiceGroupElement])
    {
        assert(self.currentEventSequence);
        self.currentChoiceEvent = [[ChoiceEvent alloc] init];
    }
    else if ([elementName isEqualToString:kChoiceElement])
    {
        assert(self.currentEventSequence && self.currentChoiceEvent);
        [self.currentChoiceEvent addChoiceWithAttributes:attributeDict];
    }
    else if ([elementName isEqualToString:kFlagToggleEventElement])
    {
        assert(self.currentEventSequence);
        FlagToggleEvent *flagEvent = [[FlagToggleEvent alloc] initWithAttributes:attributeDict];
        [self.currentEventSequence appendEvent:flagEvent];
    }
    else if ([elementName isEqualToString:kSpecialEventElement])
    {
        assert(self.currentEventSequence);
        SpecialEvent *specialEvent = [[SpecialEvent alloc] initWithAttributes:attributeDict];
        [self.currentEventSequence appendEvent:specialEvent];
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:kScenarioGroupElement])
    {
        assert(self.currentScenarioEntityId);
        self.currentScenarioEntityId = nil;
    }
    else if ([elementName isEqualToString:kSceneElement])
    {
        assert(self.currentEventSequence);

        [self.eventSequences setObject:self.currentEventSequence
                                forKey:self.currentEventSequence.sceneId];
        self.currentEventSequence = nil;
    }
    else if ([elementName isEqualToString:kChoiceGroupElement])
    {
        assert(self.currentEventSequence);
        assert(self.currentChoiceEvent);
        
        [self.currentEventSequence appendEvent:self.currentChoiceEvent];
        self.currentChoiceEvent = nil;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@: %@", NSStringFromClass([self class]), [parseError localizedDescription]);
}

@end
