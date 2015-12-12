//
//  FlagToggleEvent.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "FlagToggleEvent.h"

@interface FlagToggleEvent ()

@property (nonatomic, readwrite, copy) NSString *flagIdentifier;

@end

@implementation FlagToggleEvent

static NSString *const kFlagIdKey = @"id";

- (instancetype)initWithFlagIdentifier:(NSString *)flagIdentifier
{
    if (self = [super init])
    {
        _flagIdentifier = flagIdentifier;
        _raised = NO;
    }
    
    return self;
}


- (instancetype)initWithAttributes:(NSDictionary *)attr
{
    NSString *flagIdentifier = attr[kFlagIdKey];
    
    return [self initWithFlagIdentifier:flagIdentifier];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@", NSStringFromClass([self class]), self.flagIdentifier];
}

#pragma mark - EventProtocol

- (EventType)eventType
{
    return EventTypeFlagToggle;
}

@end
