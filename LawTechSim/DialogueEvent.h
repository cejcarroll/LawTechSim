//
//  DialogueEvent.h
//  LawTechSim
//
//  Created by Leo Shimonaka on 12/11/15.
//  Copyright © 2015 Leo Shimonaka. All rights reserved.
//

#import "EventProtocol.h"


/**
 Model for Dialogue Event, when a specific speaker speaks dialogue content
 */
@interface DialogueEvent : NSObject <EventProtocol>

/// Name of speaker of dialogue
@property (nonatomic, readonly, copy) NSString *speakerName;

/// Dialogue content spoken by speaker
@property (nonatomic, readonly, copy) NSString *content;


/**
 Initialize new DialogueEvent by name of speaker and content
 
 @param speakerName NSString speaker of dialogue
 @param content NSString content of dialogue
 
 @return new DialogueEvent
 */
- (instancetype)initWithSpeaker:(NSString *)speakerName
                        content:(NSString *)content;


/**
 Initialize new DialogueEvent with attribute dictionary
 
 @param attr NSDictionary of dialogue attributes
 
 @return new DialogueEvent
 */
- (instancetype)initWithAttributes:(NSDictionary *)attr;

@end
