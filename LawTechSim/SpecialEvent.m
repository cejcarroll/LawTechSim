//
//  SpecialEvent.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/12/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "SpecialEvent.h"

@implementation SpecialEvent

static NSString *const kEventIdKey = @"id";

- (instancetype)initWithEventId:(NSString *)eventId
{
    if (self = [super init])
    {
        _eventId = eventId;
    }
    
    return self;
}

- (instancetype)initWithAttributes:(NSDictionary *)attr
{
    NSString *eventId = attr[kEventIdKey];
    return [self initWithEventId:eventId];
}

#pragma mark - EventProtocol

- (EventType)eventType
{
    return EventTypeSpecial;
}

@end
