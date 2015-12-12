//
//  EventSequence.m
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "EventSequence.h"

@implementation EventSequence

- (instancetype)initWithSceneId:(NSString *)sceneId
{
    if (self = [super init])
    {
        // TODO: method stub
    }
    
    return self;
}

- (void)appendEvent:(id<EventProtocol>)event
{
    // TODO: method stub
}

- (id<EventProtocol>)nextEvent
{
    // TODO: method stub
    
    return nil;
}


- (void)rewindToBeginning
{
    // TODO: method stub
}



@end
