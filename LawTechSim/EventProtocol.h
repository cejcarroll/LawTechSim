//
//  EventProtocol.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import <Foundation/Foundation.h>

/// EventType are types of Events within a EventSequence
typedef NS_ENUM(NSInteger, EventType)
{
    EventTypeNone,
    EventTypeDialogue,
    EventTypeChoice,
    EventTypeFlagToggle,
    EventTypeSpecial
};

@protocol EventProtocol <NSObject>

/// An event's type
- (EventType)eventType;

@end
