//
//  EventSequence.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "EventSequence.h"

@interface EventSequence ()

/// Current location within sequence. Initially at 0
@property (nonatomic, assign) NSUInteger currentIndex;

/// Sequence of all events
@property (nonatomic, copy) NSMutableArray<id<EventProtocol>> *events;

@end

@implementation EventSequence

- (instancetype)initWithSceneId:(NSString *)sceneId
{
    if (self = [super init])
    {
        _sceneId = sceneId;
        _currentIndex = 0;
        _events = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Public

- (void)appendEvent:(id<EventProtocol>)event
{
    [self.events addObject:event];
}

- (id<EventProtocol>)nextEvent
{
    if (self.currentIndex >= self.events.count)
        return nil; // Reached end of sequence
    
    id<EventProtocol> e = self.events[self.currentIndex];
    self.currentIndex += 1;
    
    return e;
}


- (void)rewindToBeginning
{
    self.currentIndex = 0;
}


@end
