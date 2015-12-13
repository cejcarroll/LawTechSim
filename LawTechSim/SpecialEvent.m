//
//  SpecialEvent.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/12/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "SpecialEvent.h"

@implementation SpecialEvent

static NSString *const kEventIdKey                  = @"id";
static NSString *const kEventOnSuccessDestSceneKey  = @"onSuccess";
static NSString *const kEventOnFailureDestSceneKey  = @"onFailure";

- (instancetype)initWithEventId:(NSString *)eventId
                 onSuccessScene:(NSString *)onSuccessSceneId
                 onFailureScene:(NSString *)onFailureSceneId
{
    if (self = [super init])
    {
        _eventId = eventId;
        _onSuccessSceneId = onSuccessSceneId;
        _onFailureSceneId = onFailureSceneId;
    }
    
    return self;
}

- (instancetype)initWithAttributes:(NSDictionary *)attr
{
    NSString *eventId = attr[kEventIdKey];
    NSString *onSuccessScene = attr[kEventOnSuccessDestSceneKey];
    NSString *onFailScene = attr[kEventOnFailureDestSceneKey];
    
    return [self initWithEventId:eventId
                  onSuccessScene:onSuccessScene
                  onFailureScene:onFailScene];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@", NSStringFromClass([self class]), self.eventId];
}

#pragma mark - EventProtocol

- (EventType)eventType
{
    return EventTypeSpecial;
}

@end
