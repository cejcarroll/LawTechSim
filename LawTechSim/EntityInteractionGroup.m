//
//  EventSequenceGroup.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "EntityInteractionGroup.h"
#import "EventSequence.h"


@interface EntityInteractionGroup ()

/// Dictionary of SceneID to EventSequences for particular entity
@property (nonatomic, strong) NSMutableDictionary <NSString *, EventSequence *> *eventSequences;

@end

@implementation EntityInteractionGroup

- (instancetype)initWithEntityId:(NSString *)entityId
{
    if (self = [super init])
    {
        _entityId = entityId;
    }
    
    return self;
}

#pragma mark - Public

- (void)addEventSequence:(EventSequence *)sequence
{
    [self.eventSequences setObject:sequence
                            forKey:sequence.sceneId];
}

- (EventSequence *)eventSequenceForFlags:(NSSet <NSString *> *)state
{
    EventSequence *eSToReturn = nil;
    NSString *requiredFlag = nil;
    
    for (EventSequence *eS in self.eventSequences.allValues)
    {
        requiredFlag = eS.requiredFlagIdentifier;

        if (!requiredFlag ||                        // => No flag means no condition
            [state containsObject:requiredFlag])    // => Flag has been satisfied
        {
            eSToReturn = eS;
            break;
        }
    }
    
    return eSToReturn;
}

@end
