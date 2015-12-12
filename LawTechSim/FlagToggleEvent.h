//
//  FlagToggleEvent.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "EventProtocol.h"


/**
 Model for a FlagToggle Event, when an aspect of the story's completion is indicated
 */
@interface FlagToggleEvent : NSObject <EventProtocol>

/// Unique identifier for specific flag
@property (nonatomic, readonly, copy) NSString *flagIdentifier;

/// Bool representing whether this flag was raised or not. Initially NO
@property (nonatomic, assign) BOOL raised;


/**
 Initialize FlagToggleEvent by flagIdentifier
 
 @param flagIdentifier unique id for flag
 
 @return new FlagToggleEvent
 */
- (instancetype)initWithFlagIdentifier:(NSString *)flagIdentifier;


/**
 Initialize FlagToggleEvent by attribute dictionary
 
 @param attr NSDictionary of attributes
 
 @return new FlagToggleEvent
 */
- (instancetype)initWithAttributes:(NSDictionary *)attr;

@end
